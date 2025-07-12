module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    always @(*) begin
        case ({A, B})
            {4'b????, 4'b????}: begin
                A_equal = (A == B);
                A_greater = (A > B);
                A_less = (A < B);
            end
            default: begin
                A_equal = 1'b0;
                A_greater = 1'b0;
                A_less = 1'b0;
            end
        endcase
    end

endmodule