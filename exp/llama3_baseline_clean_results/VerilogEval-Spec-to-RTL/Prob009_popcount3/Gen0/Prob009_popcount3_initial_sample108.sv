module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] count;

    // Count the number of '1's in the input vector
    assign count[0] = in[0] ^ in[1] ^ in[2];
    assign count[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // Assign the count to the output
    assign out = count;

endmodule