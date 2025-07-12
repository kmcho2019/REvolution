module Mux2to1 #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Flat vectorized 2-to-1 mux assignment for all bits
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Define chunk widths: four 32-bit chunks + one 4-bit chunk = 100 bits total
    localparam CHUNK_WIDTHS [0:4] = '{32, 32, 32, 4};
    
    // Instantiate muxes for the four 32-bit chunks and one 4-bit chunk
    // Indexing for slicing
    wire [31:0] out_chunk0, out_chunk1, out_chunk2;
    wire [3:0]  out_chunk3;

    Mux2to1 #(.WIDTH(32)) mux0 (
        .a   (a[31:0]),
        .b   (b[31:0]),
        .sel (sel),
        .out (out_chunk0)
    );

    Mux2to1 #(.WIDTH(32)) mux1 (
        .a   (a[63:32]),
        .b   (b[63:32]),
        .sel (sel),
        .out (out_chunk1)
    );

    Mux2to1 #(.WIDTH(32)) mux2 (
        .a   (a[95:64]),
        .b   (b[95:64]),
        .sel (sel),
        .out (out_chunk2)
    );

    Mux2to1 #(.WIDTH(4)) mux3 (
        .a   (a[99:96]),
        .b   (b[99:96]),
        .sel (sel),
        .out (out_chunk3)
    );

    assign out = {out_chunk3, out_chunk2, out_chunk1, out_chunk0};
endmodule