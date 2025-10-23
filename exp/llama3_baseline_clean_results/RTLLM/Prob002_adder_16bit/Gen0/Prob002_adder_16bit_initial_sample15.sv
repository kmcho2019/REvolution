// Define a 1-bit full adder
module full_adder_1bit(
    input  a,
    input  b,
    input  Cin,
    output reg sum,
    output reg Cout
);
    always @(*) begin
        sum = a ^ b ^ Cin;
        Cout = (a & b) | (a & Cin) | (b & Cin);
    end
endmodule

// Define an 8-bit full adder using the 1-bit full adder
module full_adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] sum,
    output Cout
);
    wire [7:0] carry;
    assign carry[0] = Cin;
    full_adder_1bit fa0 (.a(a[0]), .b(b[0]), .Cin(carry[0]), .sum(sum[0]), .Cout(carry[1]));
    full_adder_1bit fa1 (.a(a[1]), .b(b[1]), .Cin(carry[1]), .sum(sum[1]), .Cout(carry[2]));
    full_adder_1bit fa2 (.a(a[2]), .b(b[2]), .Cin(carry[2]), .sum(sum[2]), .Cout(carry[3]));
    full_adder_1bit fa3 (.a(a[3]), .b(b[3]), .Cin(carry[3]), .sum(sum[3]), .Cout(carry[4]));
    full_adder_1bit fa4 (.a(a[4]), .b(b[4]), .Cin(carry[4]), .sum(sum[4]), .Cout(carry[5]));
    full_adder_1bit fa5 (.a(a[5]), .b(b[5]), .Cin(carry[5]), .sum(sum[5]), .Cout(carry[6]));
    full_adder_1bit fa6 (.a(a[6]), .b(b[6]), .Cin(carry[6]), .sum(sum[6]), .Cout(carry[7]));
    full_adder_1bit fa7 (.a(a[7]), .b(b[7]), .Cin(carry[7]), .sum(sum[7]), .Cout(Cout));
endmodule

// Define the 16-bit full adder using two 8-bit full adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Cout_low;
    full_adder_8bit fa_low (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .sum(y[7:0]), .Cout(Cout_low));
    full_adder_8bit fa_high (.a(a[15:8]), .b(b[15:8]), .Cin(Cout_low), .sum(y[15:8]), .Cout(Co));
endmodule