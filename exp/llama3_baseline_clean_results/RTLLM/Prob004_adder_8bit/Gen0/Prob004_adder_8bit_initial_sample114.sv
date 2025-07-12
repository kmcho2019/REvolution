module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Internal wire for carry propagation
    wire [6:0] carry;

    // Full adder for bit 0
    full_adder fa0(
       .a(a[0]),
       .b(b[0]),
       .cin(cin),
       .sum(sum[0]),
       .cout(carry[0])
    );

    // Full adders for bits 1 to 6
    generate
        for (genvar i = 1; i <= 6; i++) begin
            full_adder fa(
               .a(a[i]),
               .b(b[i]),
               .cin(carry[i-1]),
               .sum(sum[i]),
               .cout(carry[i])
            );
        end
    endgenerate

    // Full adder for bit 7
    full_adder fa7(
       .a(a[7]),
       .b(b[7]),
       .cin(carry[6]),
       .sum(sum[7]),
       .cout(cout)
    );

endmodule

// Module for a single full adder
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