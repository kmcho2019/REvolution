module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Directly calculate the count of '1's in the input vector
    // and encode the count into a 2-bit binary representation
    assign out = in[0] + in[1] + in[2];

endmodule