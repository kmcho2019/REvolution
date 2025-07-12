module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Encode comparison results as a 2-bit code:
    // 2'b10: A > B
    // 2'b01: A == B
    // 2'b00: A < B
    wire [1:0] cmp_code;
    assign cmp_code = (A > B) ? 2'b10 :
                      (A == B) ? 2'b01 : 2'b00;

    // Decode outputs from cmp_code ensuring mutual exclusivity
    assign A_greater = (cmp_code == 2'b10);
    assign A_equal   = (cmp_code == 2'b01);
    assign A_less    = (cmp_code == 2'b00);

endmodule