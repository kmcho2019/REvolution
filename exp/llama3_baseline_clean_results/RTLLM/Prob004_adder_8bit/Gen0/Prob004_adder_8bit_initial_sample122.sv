module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry;

    // Initialize the first carry with the carry-in input
    assign carry[0] = cin;

    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin: full_adder
            // Instantiate a full adder for the current bit position
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i + 1])
            );
        end
    endgenerate

    // The carry-out of the last full adder is the final carry-out
    assign cout = carry[8];

endmodule

// Define a full adder module for use in the 8-bit adder
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