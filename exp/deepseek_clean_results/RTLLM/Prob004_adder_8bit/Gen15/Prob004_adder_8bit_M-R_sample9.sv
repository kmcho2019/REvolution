module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain with one extra bit for final carry out
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Bit 0
    wire a_or_b_0 = a[0] | b[0];
    wire a_and_b_0 = a[0] & b[0];
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = a_and_b_0 | (carry[0] & a_or_b_0);

    // Bit 1
    wire a_or_b_1 = a[1] | b[1];
    wire a_and_b_1 = a[1] & b[1];
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = a_and_b_1 | (carry[1] & a_or_b_1);

    // Bit 2
    wire a_or_b_2 = a[2] | b[2];
    wire a_and_b_2 = a[2] & b[2];
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = a_and_b_2 | (carry[2] & a_or_b_2);

    // Bit 3
    wire a_or_b_3 = a[3] | b[3];
    wire a_and_b_3 = a[3] & b[3];
    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = a_and_b_3 | (carry[3] & a_or_b_3);

    // Bit 4
    wire a_or_b_4 = a[4] | b[4];
    wire a_and_b_4 = a[4] & b[4];
    assign sum[4] = a[4] ^ b[4] ^ carry[4];
    assign carry[5] = a_and_b_4 | (carry[4] & a_or_b_4);

    // Bit 5
    wire a_or_b_5 = a[5] | b[5];
    wire a_and_b_5 = a[5] & b[5];
    assign sum[5] = a[5] ^ b[5] ^ carry[5];
    assign carry[6] = a_and_b_5 | (carry[5] & a_or_b_5);

    // Bit 6
    wire a_or_b_6 = a[6] | b[6];
    wire a_and_b_6 = a[6] & b[6];
    assign sum[6] = a[6] ^ b[6] ^ carry[6];
    assign carry[7] = a_and_b_6 | (carry[6] & a_or_b_6);

    // Bit 7
    wire a_or_b_7 = a[7] | b[7];
    wire a_and_b_7 = a[7] & b[7];
    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    assign carry[8] = a_and_b_7 | (carry[7] & a_or_b_7);

    // Final carry out assignment
    assign cout = carry[WIDTH];

    /* Synthesis Optimization Notes:
     * 1. The explicit bit assignments may help some synthesis tools with mapping
     * 2. Carry chain remains the critical path - same timing characteristics
     * 3. Power and area should be identical to generate version
     */
endmodule