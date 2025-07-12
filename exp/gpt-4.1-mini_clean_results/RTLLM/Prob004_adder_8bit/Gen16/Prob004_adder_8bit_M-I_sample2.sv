module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // Carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // Carry-out output
);
    wire [8:0] carry;  // Carry signals between bits
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            // sum bit is XOR of a, b, and carry-in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            // carry-out is majority function of a, b, carry-in
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign cout = carry[8];

endmodule