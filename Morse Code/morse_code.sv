	localparam DOT_TIME = 99;
    localparam DASH_TIME = 199;
    localparam WAIT_TIME = 99;
    localparam dot = 0;
    localparam dash = 1;
    localparam STATE_WIDTH = 2;
    localparam pCNT_WIDTH = $clog2(DASH_TIME + 1);

module MORSE_CODE(
    input logic clk,
    input logic en,
    input logic [4:0] sel,
    input logic rst_n,
    output logic out
    // output logic [pCNT_WIDTH-1:0] counter_debug,
    // output logic [2:0] index_debug,
    // output logic [1:0] state_debug,
    // output logic [4:0] morse_code_debug
);


    typedef enum logic [STATE_WIDTH-1:0] {
        CHECK_CHAR,
        DOT,
        DASH,
        DELAY
    } MORSE_STATE;

    MORSE_STATE morse_current_state, morse_next_state;

    typedef struct {
        logic signal_out;
    } SIGNAL_OUT;

    SIGNAL_OUT current_signal, next_signal;
    logic [4:0] morse_code;
    logic [2:0] current_index, next_index;
    logic [pCNT_WIDTH-1:0] pCOUNTER_VAL, counter_var;
  	// reg [4:0]sel_temp;
    always_comb begin
        case (sel)
            5'b00000: morse_code = 5'bxxx10; // A: .-
            5'b00001: morse_code = 5'bx0001; // B: -...
            5'b00010: morse_code = 5'bx0101; // C: -.-.
            5'b00011: morse_code = 5'bxx001; // D: -..
            5'b00100: morse_code = 5'bxxxx0; // E: .
            5'b00101: morse_code = 5'bx0100; // F: ..-.
            5'b00110: morse_code = 5'bxx011; // G: --.
            5'b00111: morse_code = 5'bx0000; // H: ....
            5'b01000: morse_code = 5'bxxx00; // I: ..
            5'b01001: morse_code = 5'bx1110; // J: .---
            5'b01010: morse_code = 5'bxx101; // K: -.-
            5'b01011: morse_code = 5'bx0010; // L: .-..
            5'b01100: morse_code = 5'bxxx11; // M: --
            5'b01101: morse_code = 5'bxxx01; // N: -.
            5'b01110: morse_code = 5'bxx111; // O: ---
            5'b01111: morse_code = 5'bx0110; // P: .--.
            5'b10000: morse_code = 5'bx1011; // Q: --.-
            5'b10001: morse_code = 5'bxx010; // R: .-.
            5'b10010: morse_code = 5'bxx000; // S: ...
            5'b10011: morse_code = 5'bxxxx1; // T: -
            5'b10100: morse_code = 5'bxx100; // U: ..-
            5'b10101: morse_code = 5'bx1000; // V: ...-
            5'b10110: morse_code = 5'bxx110; // W: .--
            5'b10111: morse_code = 5'bx1001; // X: -..-
            5'b11000: morse_code = 5'bx1101; // Y: -.--
            5'b11001: morse_code = 5'bx0011; // Z: --..
            default: morse_code = 5'b00000;  // Default case
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            morse_current_state <= CHECK_CHAR;
            current_signal.signal_out <= 1'b0;
            counter_var <= 0;
            current_index <= 0;
        end else if (en) begin
            morse_current_state <= morse_next_state;
            current_signal <= next_signal;
            current_index <= next_index;
            if (counter_var != 0) begin
                counter_var <= counter_var - 1;
            end else begin
                counter_var <= pCOUNTER_VAL;
            end
        end else begin
            morse_current_state <= CHECK_CHAR;
            current_signal.signal_out <= 1'b0;
            counter_var <= 0;
            current_index <= 0;
        end
    end

    always_comb begin
        next_index = current_index;
        morse_next_state = CHECK_CHAR;
        next_signal.signal_out = 1'b0;
        pCOUNTER_VAL = 1'b0;
		
        case (morse_current_state)
            CHECK_CHAR: begin
                if (morse_code[current_index] == dot && en == 1) begin
                    morse_next_state = DOT;
                    next_signal.signal_out = 1'b1;
                    pCOUNTER_VAL = DOT_TIME;
                end else if (morse_code[current_index] == dash && en == 1) begin
                    morse_next_state = DASH;
                    next_signal.signal_out = 1'b1;
                    pCOUNTER_VAL = DASH_TIME;
                end else begin
                    morse_next_state = DELAY;
                    pCOUNTER_VAL = WAIT_TIME;
                    next_signal.signal_out = 1'b0;
//                   if(sel_temp==sel)	begin
//                     next_index=0;
//                   end
                end
            end

            DOT: begin
                if (counter_var == 0) begin
                    morse_next_state = DELAY;
                    next_signal.signal_out = 1'b0;
                    pCOUNTER_VAL = WAIT_TIME;
                end else begin
                    morse_next_state = morse_current_state;
                    next_signal.signal_out = 1'b1;
                end
            end

            DASH: begin
                if (counter_var == 0) begin
                    morse_next_state = DELAY;
                    next_signal.signal_out = 1'b0;
                    pCOUNTER_VAL = WAIT_TIME;
                end else begin
                    morse_next_state = morse_current_state;
                    next_signal.signal_out = 1'b1;
                end
            end

            DELAY: begin
                if (counter_var == 0) begin
                  if (current_index < 4) begin
                        next_index = current_index + 1;
                    end 
                  
                    morse_next_state = CHECK_CHAR;
                    next_signal.signal_out = 1'b0;
                end else begin
                    morse_next_state = morse_current_state;
                    next_signal.signal_out = 1'b0;
                end
            end

        endcase
    end

    assign out = current_signal.signal_out;
 //    assign counter_debug = counter_var;
 //    assign index_debug = current_index;
 //    assign state_debug = morse_current_state;
 //    assign morse_code_debug = morse_code;
	// assign sel_temp=sel;
endmodule: MORSE_CODE
