module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    case (A - B)
        -4, -3, -2, -1: begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end
        0: begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end
        1, 2, 3, 4, 5, 6, 7: begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
        default: begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    endcase
end

endmodule