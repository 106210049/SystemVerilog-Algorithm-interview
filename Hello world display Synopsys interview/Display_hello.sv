`ifndef SYNTHESIS
  	timeunit 1ps;
    timeprecision 1ps;
  `endif
`include "Second_counter.sv"
`include "Display.sv"

module Display_Hello#(parameter pNO_LED=8)(
	input logic clk,
  	input logic rst_n,
  	input logic en,
  output logic [pNO_LED-1:0][7:0]LED
);
  localparam pMAX_VAL=99;
  
  logic second_cnt_last, second_cnt_pre_last;
  logic display_en,save;
  Second_counter#(.pMAX_VAL(pMAX_VAL)) dut1 (
    .clk(clk),
    .en(en),
    .rst_n(rst_n),
    .last(second_cnt_last),
    .pre_last(second_cnt_pre_last)
  );
  assign display_en=en&second_cnt_last;
  assign save=en&second_cnt_pre_last;
  Display #(.pNO_LED(pNO_LED)) dut2(
  	.clk(clk),
    .en(display_en),
    .save(save),
    .rst_n(rst_n),
    .LED_OUT_DISPLAY(LED)
  );
  
endmodule: Display_Hello