module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    reg [3:0] result;

    always @(*) begin
        result = A - B;
        case (1'b1)
            1'b1: begin
                if (result == 4'b0) begin
                    A_equal = 1'b1;
                    A_greater = 1'b0;
                    A_less = 1'b0;
                end else if (result > 4'b0) begin
                    A_equal = 1'b0;
                    A_greater = 1'b1;
                    A_less = 1'b0;
                end else begin
                    A_equal = 1'b0;
                    A_greater = 1'b0;
                    A_less = 1'b1;
                end
            end
        endcase
    end

endmodule