module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    case({A, B})
        {4'b?, ?, ?}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 0;
        end
        default: begin
            if (A > B) begin
                A_greater = 1;
                A_equal = 0;
                A_less = 0;
            end else if (A == B) begin
                A_greater = 0;
                A_equal = 1;
                A_less = 0;
            end else begin
                A_greater = 0;
                A_equal = 0;
                A_less = 1;
            end
        end
    endcase
end

endmodule