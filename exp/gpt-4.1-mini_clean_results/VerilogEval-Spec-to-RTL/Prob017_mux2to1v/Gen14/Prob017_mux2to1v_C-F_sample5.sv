module ChunkedMux2to1 #(
    parameter WIDTH = 100,
    parameter CHUNK_WIDTH = 10
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Compute number of chunks (rounding up)
    localparam NUM_CHUNKS = (WIDTH + CHUNK_WIDTH - 1) / CHUNK_WIDTH;

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_mux
            // Calculate chunk bit indices carefully to handle last chunk which may be smaller
            localparam int CHUNK_MSB = (i+1)*CHUNK_WIDTH - 1;
            localparam int CHUNK_LSB = i*CHUNK_WIDTH;
            localparam int THIS_CHUNK_WIDTH = (CHUNK_MSB < WIDTH) ? CHUNK_WIDTH : (WIDTH - i*CHUNK_WIDTH);

            wire [THIS_CHUNK_WIDTH-1:0] a_chunk = a[CHUNK_LSB +: THIS_CHUNK_WIDTH];
            wire [THIS_CHUNK_WIDTH-1:0] b_chunk = b[CHUNK_LSB +: THIS_CHUNK_WIDTH];

            assign out[CHUNK_LSB +: THIS_CHUNK_WIDTH] = sel ? b_chunk : a_chunk;
        end
    endgenerate
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Instantiate the chunked mux with 100-bit width and 10-bit chunks
    ChunkedMux2to1 #(
        .WIDTH(100),
        .CHUNK_WIDTH(10)
    ) u_chunked_mux (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule