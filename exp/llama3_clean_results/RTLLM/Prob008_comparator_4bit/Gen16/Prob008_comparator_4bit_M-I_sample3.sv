module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    reg [4:0] diff;

    always @(*)
    begin
        diff = A - B;
        A_greater = (diff[] ==) & (diff[3:] != 0);
        A_equal = (diff[:0] == 0);
        A_less = (diff[4] == 1);
    end

endmodule