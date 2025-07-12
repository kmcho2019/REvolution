module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry;
    wire [7:0] sum_bits;

    // Bit 0 addition with initial carry-in = 0
    assign {carry[0], s[0]} = a[0] + b[0];

    // Ripple carry through bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : ripple_adder
            assign {carry[i], s[i]} = a[i] + b[i] + carry[i-1];
        end
    endgenerate

    // Overflow detection for signed 2's complement addition:
    // Overflow occurs if the sign bits of a and b are the same but differ from sum's sign bit
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule