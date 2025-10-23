module Mux2to1 #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Vectorized 2-to-1 mux assignment for all bits
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Partition inputs/outputs into 2 chunks of 50 bits each for balanced synthesis
    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin : chunk_muxes
            Mux2to1 #(.WIDTH(50)) chunk_mux (
                .a   (a[50*i +: 50]),
                .b   (b[50*i +: 50]),
                .sel (sel),
                .out (out[50*i +: 50])
            );
        end
    endgenerate
endmodule