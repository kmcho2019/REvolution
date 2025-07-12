module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

wire [8:0] sum;

assign sum = {1'b0, a} + {1'b0, b}; // perform 9-bit addition

assign s = sum[7:0]; // assign lower 8 bits of sum to output s
assign overflow = sum[8]; // assign most significant bit (9th bit) to output overflow

endmodule