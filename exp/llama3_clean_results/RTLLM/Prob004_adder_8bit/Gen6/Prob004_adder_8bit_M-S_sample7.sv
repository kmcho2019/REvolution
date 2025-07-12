// Module for a single full adder
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

// Module for an 8-bit adder
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    wire [7:0] carry;

    // First bit
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Middle bits
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

    // Last bit's carry out
    assign cout = carry[7];

endmodule