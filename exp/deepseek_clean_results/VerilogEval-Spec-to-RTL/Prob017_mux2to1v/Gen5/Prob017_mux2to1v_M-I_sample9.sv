module TopModule #(
    parameter WIDTH = 100,
    parameter CHUNK_SIZE = 32  // Optimal chunk size for most standard cells
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Hierarchical 2:1 multiplexer with explicit bitwise operation
    // Note: CHUNK_SIZE can be tuned based on target library characteristics
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : mux_gen
            assign out[i] = (sel & b[i]) | (~sel & a[i]);
        end
    endgenerate

    // For sequential implementations, consider adding:
    // - Clock gating when sel is stable
    // - Output enable control to reduce switching activity

endmodule