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
        A_greater = (~A_equal) && (A > B);
        A_less = (~A_equal) && (A < B);
    end

endmodule