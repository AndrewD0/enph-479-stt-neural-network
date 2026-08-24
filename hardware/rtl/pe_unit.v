`timescale 1ns / 1ps

//=====================================================================
// Module: pe_unit.v
// Description:
//  Single Processing Element (PE). This module computes one neuron's dot product
//  for one gate. Performs multiply-accumulate (MAC): on each enabled
//  clock cycle, multiplies one input element by a weight element and
//  adds the product to pe_output, which is a register that acts as a
//  running accumulator. The bias is preloaded as pe_output's initial
//  value when load_bias is set to HIGH.
//
// Parameters:
//  X_ELEMENT_WIDTH         - bit width of input element x
//  WEIGHT_ELEMENT_WIDTH    - bit width of weight
//  OUTPUT_ELEMENT_WIDTH    - bit width of accumulator/output
//
// Ports:
//  clk         - clock
//  rst         - reset signal
//  enable      - when high, performs one MAC operation per clock cycle
//  load_bias   - when high, bias value is added into accumulator/output
//  bias        - bias value
//  x_input     - one input element (from either x_t or h_{t-1})
//  weight      - weight value
//  pe_out      - accumulated result output 
//=====================================================================

module pe_unit #(
    parameter X_ELEMENT_WIDTH = 8,
    parameter WEIGHT_ELEMENT_WIDTH = 6,     
    parameter OUTPUT_ELEMENT_WIDTH = 24
) (
    input wire clk,
    input wire rst,
    input wire enable,

    input wire load_bias,
    input wire signed [OUTPUT_ELEMENT_WIDTH-1:0] bias,
    
    input wire signed [X_ELEMENT_WIDTH-1:0] x_input,
    input wire signed [WEIGHT_ELEMENT_WIDTH-1:0] weight,

    output reg signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_out
);

    always @(posedge clk) begin
        if (rst)
            pe_out <= 0;
        else if (load_bias)
            pe_out <= bias;
        else if (enable)
            pe_out <= pe_out + x_input * weight;
    end

endmodule