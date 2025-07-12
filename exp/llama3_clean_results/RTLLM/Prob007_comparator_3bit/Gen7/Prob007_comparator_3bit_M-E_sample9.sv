module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output logic A_greater,
    output logic A_equal,
    output logic A_less
);

logic [2:0] diff;

always_comb begin
    diff = A - B;
    A_greater = (diff > 0) ? 1'b1 : 1'b0;
    A_equal = (diff == 0) ? 1'b1 : 1'b0;
    A_less = (diff < 0) ? 1'b1 : 1'b0;
end

endmodule