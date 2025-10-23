module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry;
    wire [7:0] sum_bits;

    // First bit addition (bit 0)
    assign sum_bits[0] = a[0] ^ b[0];
    assign carry[0]    = a[0] & b[0];

    // Ripple carry addition for bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : ripple_adder
            assign sum_bits[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i]    = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    assign s = sum_bits;

    // Overflow detection:
    // Overflow occurs if a[7] == b[7] and s[7] != a[7]
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule