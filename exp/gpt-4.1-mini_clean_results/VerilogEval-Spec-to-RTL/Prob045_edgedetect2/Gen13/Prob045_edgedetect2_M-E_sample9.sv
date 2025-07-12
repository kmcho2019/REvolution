module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    // Per-bit previous state registers
    reg prev_bit [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : EDGE_DETECTOR
            always @(posedge clk) begin
                anyedge[i] <= in[i] ^ prev_bit[i];
                prev_bit[i] <= in[i];
            end
        end
    endgenerate
endmodule