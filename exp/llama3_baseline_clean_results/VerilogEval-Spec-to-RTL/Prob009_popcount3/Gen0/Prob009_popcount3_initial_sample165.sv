module TopModule(
    input [2:0] in,
    output [1:0] out
);

// Count the number of '1's in the input vector
wire [1:0] count;
assign count = (in[0] + in[1] + in[2]);

// Output the count as a 2-bit binary number
assign out = count;

endmodule