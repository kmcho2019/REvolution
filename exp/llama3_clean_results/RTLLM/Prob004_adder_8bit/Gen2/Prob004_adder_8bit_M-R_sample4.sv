module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [6:0] carry;

// Least significant bit
bitwise_adder ba0(
   .a(a[0]),
   .b(b[0]),
   .cin(cin),
   .sum(sum[0]),
   .cout(carry[0])
);

// Middle bits
genvar i;
generate
    for (i = 1; i < 7; i++) begin
        bitwise_adder ba(
           .a(a[i]),
           .b(b[i]),
           .cin(carry[i-1]),
           .sum(sum[i]),
           .cout(carry[i])
        );
    end
endgenerate

// Most significant bit
bitwise_adder ba7(
   .a(a[7]),
   .b(b[7]),
   .cin(carry[6]),
   .sum(sum[7]),
   .cout(cout)
);

endmodule

module bitwise_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule