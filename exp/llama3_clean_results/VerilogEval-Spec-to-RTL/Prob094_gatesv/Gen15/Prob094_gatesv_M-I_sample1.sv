module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Directly implement bitwise operations without a separate module
    // to minimize overhead and improve readability

    // out_both: Each bit indicates if the input bit and its left neighbor are '1'
    assign out_both[0] = 1'b0; // No left neighbor for in[3]
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0; // No calculation needed for the last bit as per problem statement

    // out_any: Each bit indicates if the input bit or its right neighbor is '1'
    assign out_any[0] = in[0] | in[3]; // Wrap around for in[0]'s right neighbor
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different: Each bit indicates if the input bit is different from its left neighbor
    assign out_different[0] = in[0] ^ in[3]; // Wrap around for in[0]'s left neighbor
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    assign out_different[3] = in[3] ^ in[2];

endmodule