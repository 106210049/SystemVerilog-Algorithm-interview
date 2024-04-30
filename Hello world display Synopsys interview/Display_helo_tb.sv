
module Display_Hello_tb;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in ns
    localparam pNO_LED = 8; // Number of LEDs

    // Signals
    logic clk = 0;
    logic rst_n = 1;
    logic en = 1;
  logic [pNO_LED-1:0][7:0] LED; // 8 LEDs, each 8 bits wide

    // Instantiate the module under test
    Display_Hello #(.pNO_LED(pNO_LED)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .LED(LED)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Reset assertion
    initial begin
      $dumpfile("dump.vcd"); $dumpvars;
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
    end

    // Display LED values
  always @(LED) begin
        $display("LED values:");
        for (int i = 0; i < pNO_LED; i++) begin
            $display("LED[%0d]: %h", i, LED[i]);
        end
    end

    // End simulation
    initial begin
        #7000; // Run simulation for a while
        $finish; // Stop simulation
    end

endmodule
