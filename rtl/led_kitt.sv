//
// LED flash sequence modelled on KITT car
//
// One full forward + reverse sweep per second
//
`include "defines.svh"

module led_kitt #(
  parameter CLK_IN_MHZ   = 125,
            LED_POLARITY = 1'b0  )
(
  input              clk_i,
  input              rstn_i,
  output logic [7:0] display_o
);


// Local Parameters

  localparam [0:13] [7:0] LED_DISP = {
    8'b00000001,
    8'b00000010,
    8'b00000100,
    8'b00001000,
    8'b00010000,
    8'b00100000,
    8'b01000000,
    8'b10000000,
    8'b01000000,
    8'b00100000,
    8'b00010000,
    8'b00001000,
    8'b00000100,
    8'b00000010
  } ;
  
  localparam SYS_FREQ = CLK_IN_MHZ * 1000 * 1000 / 14;

// Signal Declarations
  
  logic [$clog2(SYS_FREQ)-1:0] prescaler;
  logic                        prescaler_tc;
  logic                  [3:0] display_counter;     

// Module Behaviour

`ifndef SIM

  // Prescaler generates 1Hz pulse to enable display counter
  always_ff @(posedge clk_i, negedge rstn_i) begin : prescale
    if (!rstn_i) prescaler  <= 'b0;
    else         prescaler  <= prescaler_tc ? 'b0 : prescaler + 1'b1;
  end : prescale
  
  assign prescaler_tc = (prescaler == SYS_FREQ - 1) ;

`else 

  // Disable prescaler for simulation
  assign prescaler    = 'b0;
  assign prescaler_tc = 1'b1; 

`endif

  // Display Counter - Increment once per prescaler pulse to value 13
  always_ff @(posedge clk_i, negedge rstn_i) begin : dsply_cntr
    if (!rstn_i) display_counter <= 'b0;
    else if (prescaler_tc) display_counter  <= display_counter > 12 ? 'b0 : display_counter + 1'b1;
  end : dsply_cntr

  // Display Decoder
  always_ff @(posedge clk_i, negedge rstn_i) begin : dsply_dcdr
    if (!rstn_i) display_o <= 'b0;
    else         display_o <= LED_POLARITY ? LED_DISP[display_counter] : ~LED_DISP[display_counter] ;
  end : dsply_dcdr

endmodule
