module Mux2to1_Nbit #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Simple 2-to-1 mux for WIDTH-bit vector using ternary operator
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Parameter for chunk size
    localparam CHUNK_SIZE = 10;
    localparam NUM_CHUNKS = 100 / CHUNK_SIZE;

    // Generate 10-bit mux instances for each chunk
    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_muxes
            Mux2to1_Nbit #(.WIDTH(CHUNK_SIZE)) chunk_mux (
                .a   (a[(i+1)*CHUNK_SIZE-1 : i*CHUNK_SIZE]),
                .b   (b[(i+1)*CHUNK_SIZE-1 : i*CHUNK_SIZE]),
                .sel (sel),
                .out (out[(i+1)*CHUNK_SIZE-1 : i*CHUNK_SIZE])
            );
        end
    endgenerate
endmodule