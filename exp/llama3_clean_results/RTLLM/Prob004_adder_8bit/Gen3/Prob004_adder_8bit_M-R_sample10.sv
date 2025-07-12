module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry;

    assign carry[0] = cin;
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            full_adder fa(
               .a(a[i]),
               .b(b[i]),
               .cin(carry[i]),
               .sum(sum[i]),
               .cout(carry[i + 1])
            );
        end
    endgenerate

    assign cout = carry[8];

endmodule