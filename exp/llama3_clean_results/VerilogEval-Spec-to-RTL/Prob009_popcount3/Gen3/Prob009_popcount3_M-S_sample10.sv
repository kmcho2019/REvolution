module TopModule(
    input [2:0] in,
    output [1:0] out
);
    
    // Directly sum the input bits to count the number of '1's
    // The result is a binary encoding of the count, fitting the 2-bit output
    assign out = in[0] + in[1] + in[2];

endmodule