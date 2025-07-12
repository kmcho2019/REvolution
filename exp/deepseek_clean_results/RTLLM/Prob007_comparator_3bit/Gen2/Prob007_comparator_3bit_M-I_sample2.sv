module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Encoded comparison result
    wire [1:0] cmp_result;
    assign cmp_result = (A == B) ? 2'b00 :
                       (A < B)  ? 2'b01 :
                                   2'b10;

    // Decode to mutually exclusive outputs
    assign A_equal    = (cmp_result == 2'b00);
    assign A_less     = (cmp_result == 2'b01);
    assign A_greater  = (cmp_result == 2'b10);

endmodule