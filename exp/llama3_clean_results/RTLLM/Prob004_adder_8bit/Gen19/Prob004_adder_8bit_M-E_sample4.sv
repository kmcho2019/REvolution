module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    wire [7:0] sum_no_carry;
    wire [7:0] carry_in;
    wire [7:0] carry_out;

    // Calculate sum without considering carry
    assign sum_no_carry = a ^ b;

    // Calculate carry signal for each bit position
    assign carry_in[0] = cin;
    assign carry_out[0] = (a[0] & b[0]) | (a[0] & sum_no_carry[0]) | (b[0] & sum_no_carry[0]);
    assign sum[0] = sum_no_carry[0] ^ carry_in[0];

    // Propagate carry signal to subsequent bit positions
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry_in[i] = carry_out[i-1];
            assign carry_out[i] = (a[i] & b[i]) | (a[i] & sum_no_carry[i]) | (b[i] & sum_no_carry[i]);
            assign sum[i] = sum_no_carry[i] ^ carry_in[i];
        end
    endgenerate

    // Final carry-out signal
    assign cout = carry_out[7];

endmodule