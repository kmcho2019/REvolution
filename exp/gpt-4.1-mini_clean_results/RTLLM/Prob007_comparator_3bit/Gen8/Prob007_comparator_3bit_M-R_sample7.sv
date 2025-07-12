module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 2-bit code to represent comparison:
    // 10: A > B
    // 01: A == B
    // 00: A < B
    wire [1:0] cmp_code;

    assign cmp_code = (A > B) ? 2'b10 :
                      (A == B) ? 2'b01 : 2'b00;

    assign A_greater = cmp_code[1];
    assign A_equal   = cmp_code[0] & (~cmp_code[1]);
    assign A_less    = ~(cmp_code[1] | cmp_code[0]);

endmodule