module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Attempting a minor optimization by splitting the assignment
    // This might help the synthesis tool in optimizing the logic further
    assign out[ 7: 0] = in[31:24];
    assign out[15: 8] = in[23:16];
    assign out[23:16] = in[15: 8];
    assign out[31:24] = in[ 7: 0];

endmodule