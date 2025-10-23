module BitEdgeDetector (
    input clk,
    input in_bit,
    output reg anyedge_bit
);
    reg prev_bit;

    always @(posedge clk) begin
        anyedge_bit <= in_bit ^ prev_bit;
        prev_bit <= in_bit;
    end
endmodule

module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_edge_detectors
            BitEdgeDetector bed (
                .clk(clk),
                .in_bit(in[i]),
                .anyedge_bit(anyedge[i])
            );
        end
    endgenerate
endmodule