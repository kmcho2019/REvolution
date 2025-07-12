module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    case ({A > B, A == B, A < B})
        3'b100: begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
        3'b010: begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end
        3'b001: begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end
        default: begin  // Should never happen as cases are mutually exclusive
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    endcase
end

endmodule