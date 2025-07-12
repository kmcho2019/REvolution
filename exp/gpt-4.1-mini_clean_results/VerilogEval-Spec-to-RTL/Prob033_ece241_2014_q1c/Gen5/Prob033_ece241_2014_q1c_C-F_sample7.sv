module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry;
    wire [7:0] sum;

    assign carry[0] = 1'b0;

    // Bit 0 full adder
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);

    // Bits 1 to 7 full adders (ripple carry)
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : full_adders
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign s = sum;

    // Overflow detection: XOR of carry into and carry out of MSB
    assign overflow = carry[7] ^ carry[8];

endmodule