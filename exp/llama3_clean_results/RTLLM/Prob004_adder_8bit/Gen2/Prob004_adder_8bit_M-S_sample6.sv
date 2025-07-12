module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal carry wires
wire [6:0] carry;

// First bit adder
full_adder fa0(
   .a(a[0]),
   .b(b[0]),
   .cin(cin),
   .sum(sum[0]),
   .cout(carry[0])
);

// Middle bits adders
genvar i;
generate
    for (i = 1; i < 7; i++) begin
        full_adder fa(
           .a(a[i]),
           .b(b[i]),
           .cin(carry[i-1]),
           .sum(sum[i]),
           .cout(carry[i])
        );
    end
endgenerate

// Last bit adder
full_adder fa7(
   .a(a[7]),
   .b(b[7]),
   .cin(carry[6]),
   .sum(sum[7]),
   .cout(cout)
);

endmodule

module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule