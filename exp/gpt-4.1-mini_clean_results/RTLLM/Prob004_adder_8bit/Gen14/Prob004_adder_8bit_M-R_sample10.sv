module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] carry; // internal carry signals, carry[0] = first carry-out from bit0

    // Bit 0 full adder
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : adder_bits
            // sum bit i
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            // carry out bit i
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    assign cout = carry[7];

endmodule