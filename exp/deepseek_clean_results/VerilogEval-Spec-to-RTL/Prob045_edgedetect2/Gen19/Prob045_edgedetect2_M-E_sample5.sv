module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    // Individual bit storage and edge detection
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_edge_detector
            reg prev_bit;
            wire rising_edge = ~prev_bit & in[i];
            wire falling_edge = prev_bit & ~in[i];
            wire bit_edge = rising_edge | falling_edge;
            
            always @(posedge clk) begin
                prev_bit <= in[i];
            end
            
            assign anyedge[i] = bit_edge;
        end
    endgenerate

endmodule