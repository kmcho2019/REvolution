module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Truth table implementation using bitwise operations
    assign out[0] = in[0] ^ in[1] ^ in[2];
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

endmodule