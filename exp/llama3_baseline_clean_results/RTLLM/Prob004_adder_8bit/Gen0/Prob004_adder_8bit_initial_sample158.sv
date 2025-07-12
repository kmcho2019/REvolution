// Define a module for a full adder
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

// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input  cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] carry;

    // First full adder (bit 0)
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Remaining full adders (bits 1-7)
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Final carry-out
    assign cout = carry[7];
endmodule