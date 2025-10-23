module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Directly implement the population count logic
    assign out = (in[0] + in[1] + in[2]) % 4;

    // Alternatively, enumerate the possibilities:
    // assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);
    // assign out[0] = in[0] ^ in[1] ^ in[2];

    // However, since we are counting and the result is small, 
    // using the simplified addition approach is more straightforward.

endmodule