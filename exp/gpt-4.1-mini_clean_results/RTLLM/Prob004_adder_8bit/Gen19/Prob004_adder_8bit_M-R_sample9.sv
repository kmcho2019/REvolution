module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] c; // carry signals between bits

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_adder_bits
            wire a_bit = a[i];
            wire b_bit = b[i];
            wire cin_bit = (i == 0) ? cin : c[i-1];

            // Sum bit calculation
            assign sum[i] = a_bit ^ b_bit ^ cin_bit;

            // Carry out calculation
            assign c[i] = (a_bit & b_bit) | (a_bit & cin_bit) | (b_bit & cin_bit);
        end
    endgenerate

    assign cout = c[7];
endmodule