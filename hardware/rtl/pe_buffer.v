`timescale 1ns / 1ps

//=====================================================================
// Module: pe_buffer.v
// Description:
//  Processing Element (PE) buffer. This module stores the accumulated
//  values for all four PE output buffers on each enabled cycle and holds
//  them for the LSTM EPU to read.
//
// Parameters:
//  OUTPUT_ELEMENT_WIDTH    - bit width of PE output
//
// Ports:
//  clk             - clock
//  rst             - reset signal
//  enable          - when high, store pe_output into selected buffer
//  buffer_select   - select which buffer to write into: 0 = i, 1 = f, 2 = o, 3 = c
//  pe_i            - stored result for input gate
//  pe_f            - stored result for forget gate
//  pe_o            - stored result for output gate
//  pe_c            - stored result for candidate
//=====================================================================

module pe_buffer #(
    parameter OUTPUT_ELEMENT_WIDTH = 24
) (
    input wire clk,
    input wire rst,
    input wire enable,
    
    input wire signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_output,
    input wire [1:0] buffer_select, // Two bits to represent 4 different PE output buffers

    output reg signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_i,
    output reg signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_f,
    output reg signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_o,
    output reg signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_c
);

    always @(posedge clk) begin
        if (rst) begin
            pe_i <= 0;
            pe_f <= 0;
            pe_o <= 0;
            pe_c <= 0;
        end
        else if (enable) begin
            if(buffer_select == 2'd0)
                pe_i <= pe_output;
            else if (buffer_select == 2'd1)
                pe_f <= pe_output;
            else if (buffer_select == 2'd2)
                pe_o <= pe_output;
            else if (buffer_select == 2'd3)
                pe_c <= pe_output;
        end 
    end
endmodule