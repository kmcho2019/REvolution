module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Count the number of '1's in the input vector
    wire [1:0] count;

    // Counting logic
    assign count[0] = in[0] ^ in[1] ^ in[2];
    assign count[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

    // Output the count
    assign out = count;

endmodule