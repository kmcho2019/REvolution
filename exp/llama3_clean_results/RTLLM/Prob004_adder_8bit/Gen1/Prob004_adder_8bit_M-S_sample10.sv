module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry;

    // Initialize the carry-in for the least significant bit (LSB)
    assign carry[0] = cin;

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            full_adder fa(
               .a(a[i]),
               .b(b[i]),
               .cin(i == 0? cin : carry[i-1]),
               .sum(sum[i]),
               .cout(i == 7? cout : carry[i])
            );
        end
    endgenerate

endmodule

// Full adder module
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