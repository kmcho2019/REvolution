module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    always @(*) begin
        if (A > B) begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end else if (A < B) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end
    end

endmodule