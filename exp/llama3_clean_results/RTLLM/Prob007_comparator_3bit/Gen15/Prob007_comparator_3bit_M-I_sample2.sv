module comparator_3bit(
    input logic [2:0] A,
    input logic [2:0] B,
    output logic A_greater,
    output logic A_equal,
    output logic A_less
);

assign A_greater = (A > B) ? 1'b1 : 1'b0;
assign A_equal = (A == B) ? 1'b1 : 1'b0;
assign A_less = (A < B) ? 1'b1 : 1'b0;

endmodule