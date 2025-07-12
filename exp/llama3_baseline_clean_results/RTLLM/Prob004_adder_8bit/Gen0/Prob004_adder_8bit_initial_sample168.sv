// Full Adder Module
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

// 8-bit Adder Module
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    wire [6:0] carry;

    // First Full Adder
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Subsequent Full Adders
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

    // Last Carry Out
    assign cout = carry[7];
endmodule