/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Pin assignments:
  // ui_in[7:0]   = data_in[7:0]  (8-bit data input)
  // uio_in[7:0]  = key_in[7:0]   (8-bit key input)
  // uo_out[7:0]  = data_out[7:0] (8-bit encrypted output)
  // uio_out[7:0] = status/debug  (bit 0 = ready, bits 3:0 = round_count)
  
  wire [7:0] data_in;
  wire [7:0] key_in;
  wire [7:0] data_out;
  wire ready;
  wire [3:0] round_count;
  wire [3:0] state;

 // Input mapping
  assign data_in = ui_in[7:0];    // Full 8-bit data
  assign key_in = uio_in[7:0];    // Full 8-bit key
  
  // Output mapping
  assign uo_out = data_out;       // 8-bit encrypted output
  assign uio_out = {state, round_count};  // Debug: state and round counter
  assign uio_oe = 8'b11111111;    // All bidirectional pins as outputs
    
   // Instantiate the AES-lite controller (auto-start on reset)
  aes_lite_ctrl aes_lite_ctrl (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .key_in(key_in),
    .data_out(data_out),
    .ready(ready),
    .round_count(round_count),
    .state(state)
  );
  
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ready, 1'b0};

endmodule
