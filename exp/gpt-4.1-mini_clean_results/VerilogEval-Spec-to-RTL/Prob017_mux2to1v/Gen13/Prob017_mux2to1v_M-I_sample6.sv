module Mux2to1 #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Number of bits per mux block
    localparam BLOCK_WIDTH = 10;
    // Number of mux blocks
    localparam NUM_BLOCKS = 100 / BLOCK_WIDTH;

    genvar i;
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : mux_blocks
            Mux2to1 #(.WIDTH(BLOCK_WIDTH)) u_mux (
                .a   (a[i*BLOCK_WIDTH +: BLOCK_WIDTH]),
                .b   (b[i*BLOCK_WIDTH +: BLOCK_WIDTH]),
                .sel (sel),
                .out (out[i*BLOCK_WIDTH +: BLOCK_WIDTH])
            );
        end
    endgenerate
endmodule