module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    reg A_greater_reg;
    reg A_equal_reg;
    reg A_less_reg;

    always @(*) begin
        case (A - B)
            -4: begin
                A_greater_reg = 1'b0;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b1;
            end
            -3: begin
                A_greater_reg = 1'b0;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b1;
            end
            -2: begin
                A_greater_reg = 1'b0;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b1;
            end
            -1: begin
                A_greater_reg = 1'b0;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b1;
            end
            0: begin
                A_greater_reg = 1'b0;
                A_equal_reg   = 1'b1;
                A_less_reg    = 1'b0;
            end
            1: begin
                A_greater_reg = 1'b1;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b0;
            end
            2: begin
                A_greater_reg = 1'b1;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b0;
            end
            3: begin
                A_greater_reg = 1'b1;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b0;
            end
            4: begin
                A_greater_reg = 1'b1;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b0;
            end
            default: begin
                A_greater_reg = 1'b0;
                A_equal_reg   = 1'b0;
                A_less_reg    = 1'b0;
            end
        endcase
    end

    assign A_greater = A_greater_reg;
    assign A_equal   = A_equal_reg;
    assign A_less    = A_less_reg;

endmodule