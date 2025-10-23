module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    // Directly assign each bit of out to the corresponding bit of in, but in reverse order
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

    // Alternatively, we could use a loop in a more complex scenario, but for an 8-bit input, direct assignment is more straightforward and efficient.

endmodule