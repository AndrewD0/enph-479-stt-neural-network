`timescale 1ns / 1ps

module pe_buffer #(
    parameter X_ELEMENT_WIDTH = 8,
    parameter WEIGHT_ELEMENT_WIDTH = 6,
    parameter OUTPUT_ELEMENT_WIDTH = 24
) (
    input wire clk,
    input wire rst,
    input wire enable,
    
    input wire signed [OUTPUT_ELEMENT_WIDTH-1:0] pe_output,
    input wire [1:0] buffer_select,

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