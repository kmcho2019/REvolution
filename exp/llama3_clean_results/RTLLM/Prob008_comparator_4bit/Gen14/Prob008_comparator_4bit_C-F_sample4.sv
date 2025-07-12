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
        if (A_equal) begin
            A_greater = 1'b0;
            A_less = 1'b0;
        end else if (A > B) begin
            A_greater = 1'b1;
            A_less = 1'b0;
        end else begin
            A_greater = 1'b0;
            A_less = 1'b1;
        end
    end

endmodule