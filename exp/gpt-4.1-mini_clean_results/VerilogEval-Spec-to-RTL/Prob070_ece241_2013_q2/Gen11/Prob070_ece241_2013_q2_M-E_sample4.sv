module TopModule(
    input  a, // MSB
    input  b,
    input  c,
    input  d, // LSB
    output out_sop,
    output out_pos
);

    // Pack inputs into a 4-bit vector for easy comparison
    wire [3:0] in_vec = {a,b,c,d};

    // Define the logic-1 values explicitly
    // decimal 2  = 4'b0010
    // decimal 7  = 4'b0111
    // decimal 15 = 4'b1111
    wire is_2  = (in_vec == 4'b0010);
    wire is_7  = (in_vec == 4'b0111);
    wire is_15 = (in_vec == 4'b1111);

    // out_sop is high if input equals any of the logic-1 values
    assign out_sop = is_2 | is_7 | is_15;

    // Define logic-0 values explicitly (decimal):
    // 0 (0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
    wire is_0  = (in_vec == 4'b0000);
    wire is_1  = (in_vec == 4'b0001);
    wire is_4  = (in_vec == 4'b0100);
    wire is_5  = (in_vec == 4'b0101);
    wire is_6  = (in_vec == 4'b0110);
    wire is_9  = (in_vec == 4'b1001);
    wire is_10 = (in_vec == 4'b1010);
    wire is_13 = (in_vec == 4'b1101);
    wire is_14 = (in_vec == 4'b1110);

    // Zero detection: high if input equals any logic-0 value
    wire is_zero = is_0 | is_1 | is_4 | is_5 | is_6 | is_9 | is_10 | is_13 | is_14;

    // out_pos in product-of-sums form is high only if input is NOT zero,
    // so output is 1 when is_zero=0, else 0
    assign out_pos = ~is_zero;

endmodule