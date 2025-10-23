module TopModule(
    input  [2:0] in,
    output [1:0] out
);

wire cout1, cout2;
wire sum1, sum2;

// Count the number of '1's in the input vector
assign sum1 = in[0] ^ in[1];
assign cout1 = in[0] & in[1];

assign sum2 = sum1 ^ in[2];
assign cout2 = (sum1 & in[2]) | cout1;

// Assign the count to the output
assign out[0] = sum2;
assign out[1] = cout2;

endmodule