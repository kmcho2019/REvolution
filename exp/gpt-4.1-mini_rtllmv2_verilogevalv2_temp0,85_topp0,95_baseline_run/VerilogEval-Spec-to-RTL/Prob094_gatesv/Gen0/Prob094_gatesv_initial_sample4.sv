module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: each bit indicates if both the bit and its left neighbor are 1
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0; // no neighbor to the left for in[3]

    // out_any: each bit indicates if either the bit or its right neighbor are 1
    assign out_any[0] = 1'b0; // no neighbor to the right for in[0]
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different: each bit indicates if bit differs from its neighbor to the left (wrap around)
    // neighbor to left of in[i] is in[(i+1)%4]
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule