module adder_8bit(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry; // internal carry signals between bits

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            wire in_carry = (i == 0) ? cin : carry[i-1];
            assign sum[i]  = a[i] ^ b[i] ^ in_carry;
            assign carry[i] = (a[i] & b[i]) | (b[i] & in_carry) | (a[i] & in_carry);
        end
    endgenerate

    assign cout = carry[7];
endmodule