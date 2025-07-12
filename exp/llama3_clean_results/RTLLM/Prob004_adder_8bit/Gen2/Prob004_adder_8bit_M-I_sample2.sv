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

// 8-bit adder module
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
        for (i = 1; i < 8; i++) begin
            assign carry[i] = (a[i-1] & b[i-1]) | (a[i-1] & carry[i-1]) | (b[i-1] & carry[i-1]);
        end
    endgenerate

    // Instantiate full adders for each bit
    genvar j;
    generate
        for (j = 0; j < 8; j++) begin
            full_adder fa(
               .a(a[j]),
               .b(b[j]),
               .cin(j == 0? cin : carry[j-1]),
               .sum(sum[j]),
               .cout(j == 7? cout : carry[j])
            );
        end
    endgenerate

endmodule