module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire [8:0] sum;  // 9-bit sum to capture carry-out

assign sum = {1'b0, a} + {1'b0, b};  // perform 9-bit addition
assign s = sum[7:0];  // assign lower 8 bits to output s
assign overflow = sum[8];  // assign MSB (carry-out) to overflow

endmodule