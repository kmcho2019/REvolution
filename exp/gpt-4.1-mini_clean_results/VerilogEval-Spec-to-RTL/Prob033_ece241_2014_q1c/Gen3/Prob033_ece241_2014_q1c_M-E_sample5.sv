module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] sum;
    wire [7:0] carry;

    // Bit 0 full adder
    assign sum[0] = a[0] ^ b[0];
    assign carry[0] = a[0] & b[0];

    // Bits 1 to 7 full adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : full_adders
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    assign s = sum;

    // Overflow is detected by XOR of carry into MSB and carry out of MSB
    assign overflow = carry[6] ^ carry[7];

endmodule