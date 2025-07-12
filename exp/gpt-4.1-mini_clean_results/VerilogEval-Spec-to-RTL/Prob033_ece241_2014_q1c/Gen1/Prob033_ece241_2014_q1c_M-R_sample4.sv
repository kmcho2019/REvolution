module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire signed [8:0] sum_signed;
wire signed [7:0] a_signed = a;
wire signed [7:0] b_signed = b;

assign sum_signed = a_signed + b_signed;
assign s = sum_signed[7:0];

// Overflow occurs if the sum is outside the range representable by 8-bit signed number
// i.e., sum_signed does not fit in 8 bits signed
assign overflow = (sum_signed > 127) || (sum_signed < -128);

endmodule