// Full Adder module
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

// 8-bit Adder module
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    wire [7:0] c;

    // Initialize carry-in for the first full adder
    assign c[0] = cin;

    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(i == 0 ? cin : c[i-1]),
                .sum(sum[i]),
                .cout(c[i])
            );
        end
    endgenerate

    // Assign carry-out
    assign cout = c[7];
endmodule