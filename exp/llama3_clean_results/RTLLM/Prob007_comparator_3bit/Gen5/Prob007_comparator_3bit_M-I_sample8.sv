module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output logic A_greater,
    output logic A_equal,
    output logic A_less
);

always_comb begin
    A_greater = (A > B) ? 1'b1 : 1'b0;
    A_equal = (A == B) ? 1'b1 : 1'b0;
    A_less = (A < B) ? 1'b1 : 1'b0;
end

endmodule