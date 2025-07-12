module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    wire [7:0] carry;

    // Initialize carry-in for the first full adder
    assign carry[0] = cin;

    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin: full_adder_instance
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i + 1])
            );
        end
    endgenerate

    // Assign carry-out from the last full adder
    assign cout = carry[8];

endmodule

// Module for a single full adder
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule