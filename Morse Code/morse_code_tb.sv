
`ifndef SYNTHESIS
        timeunit 1ps;
        timeprecision 1ps;
    `endif

module tb_MORSE_CODE;
    localparam DOT_TIME= 99;
    localparam DASH_TIME= 199;
    localparam WAIT_TIME= 99;
    localparam dot= 0;
    localparam dash= 1;

    
    // Parameters
    localparam CLK_PERIOD = 10;

    // Inputs
    logic clk;
    logic en;
    logic [4:0] sel;
    logic rst_n;

    // Outputs
    logic out;
   //  logic [pCNT_WIDTH-1:0] counter_debug;
  	// logic [2:0] index_debug;
   //  logic [1:0] state_debug;
  	// logic [4:0] morse_code_debug;
    // Instantiate the MORSE_CODE module
    MORSE_CODE uut (
        .clk(clk),
        .en(en),
        .sel(sel),
        .rst_n(rst_n),
        .out(out)
        // .counter_debug(counter_debug),
        // .index_debug(index_debug),
        // .state_debug(state_debug),
        // .morse_code_debug(morse_code_debug)
    );

    // Clock generation
    initial begin
        $dumpfile("tb_MORSE_CODE.vcd");
        $dumpvars(0, tb_MORSE_CODE);
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize inputs
        en = 0;
        sel = 0;
        rst_n = 0;

        // Reset the design
        #(2*CLK_PERIOD);
        rst_n = 1;

        // Enable the design and provide inputs
        #(2*CLK_PERIOD);
        en = 1;

        // Test character 'A' (".-")
        sel = 5'b00000;
      	#(700*CLK_PERIOD);
      	en=0;	 #(2*CLK_PERIOD);
		en=1;
//         Test character 'B' ("-...")
        sel = 5'b00001;
      	#(1000*CLK_PERIOD);
		en=0;	 #(2*CLK_PERIOD);
		en=1;
//         // Test character 'C' ("-.-.")
        sel = 5'b00010;
      	#(1000*CLK_PERIOD);

        // Additional characters can be tested similarly

        // Disable the design
        en = 0;
        #(10*CLK_PERIOD);

        // Finish the simulation
        $finish;
    end

    // Monitor outputs
//     initial begin
//         $monitor("Time: %0t | clk: %b | en: %b | sel: %b | rst_n: %b | out: %b | index_debug: %d | state_debug: %d | counter_debug: %d | morse_code_debug: %5b", 
//                  $time, clk, en, sel, rst_n, out, index_debug, state_debug, counter_debug,morse_code_debug);
//     end

endmodule
