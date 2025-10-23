module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;  // Internal carry signals for each bit

    genvar i;

    // Generate block for bitwise full adder logic
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_full_adder
            wire c_in = (i == 0) ? cin : carry[i-1];
            wire a_bit = a[i];
            wire b_bit = b[i];

            // Sum is XOR of inputs and carry-in
            assign sum[i] = a_bit ^ b_bit ^ c_in;
            // Carry-out is majority function of a, b, c_in
            assign carry[i] = (a_bit & b_bit) | (b_bit & c_in) | (a_bit & c_in);
        end
    endgenerate

    assign cout = carry[7];
endmodule