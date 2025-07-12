module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [6:0] carry;

// Level 1: Bitwise adders
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        if (i == 0) begin
            bitwise_adder ba(
               .a(a[i]),
               .b(b[i]),
               .cin(cin),
               .sum(sum[i]),
               .cout(carry[i])
            );
        end else begin
            bitwise_adder ba(
               .a(a[i]),
               .b(b[i]),
               .cin(carry[i-1]),
               .sum(sum[i]),
               .cout(carry[i])
            );
        end
    end
endgenerate

assign cout = carry[7];

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