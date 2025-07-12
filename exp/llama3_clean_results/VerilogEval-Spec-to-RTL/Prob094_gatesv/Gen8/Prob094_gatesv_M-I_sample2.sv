module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Direct assignments for out_both
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];
    assign out_both[3] = 1'b0; // Since there's no left neighbor for in[3]

    // Direct assignments for out_any
    assign out_any[0] = in[0];
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // Using XOR for out_different, considering wrap-around
    assign out_different[0] = in[0] ^ in[3]; // Wrap-around for in[0]
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    assign out_different[3] = in[3] ^ in[2];

endmodule