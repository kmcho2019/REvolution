module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    always @(*)
    begin
        A_equal = (A == B);
        A_greater = (A > B) & ~A_equal;
        A_less = (A < B) & ~A_equal;
    end

endmodule