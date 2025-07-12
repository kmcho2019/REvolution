module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

always @(*)
begin
    A_greater = (A > B);
    A_equal = (A == B);
    A_less = (A < B);
end

endmodule