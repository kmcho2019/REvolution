module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate block to create 8 full adders
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            // Full adder logic
            wire a_bit, b_bit, carry_in, sum_bit, carry_out;
            assign a_bit = a[i];
            assign b_bit = b[i];
            assign carry_in = (i == 0) ? cin : (a[i-1] & b[i-1]) | (a[i-1] & carry_in) | (b[i-1] & carry_in);
            assign sum_bit = a_bit ^ b_bit ^ carry_in;
            assign carry_out = (a_bit & b_bit) | (a_bit & carry_in) | (b_bit & carry_in);
            assign sum[i] = sum_bit;
            assign cout = (i == 7) ? carry_out : 1'b0;
        end
    endgenerate

endmodule