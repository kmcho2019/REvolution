module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0] is 1 if there is an odd number of ones (1 or 3)
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1] is 1 if there are at least two ones
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule