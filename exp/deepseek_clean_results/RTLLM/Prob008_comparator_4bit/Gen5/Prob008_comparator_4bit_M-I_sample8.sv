module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    case ({A == B, A > B})
        2'b10: begin  // Equal
            A_equal = 1'b1;
            A_greater = 1'b0;
            A_less = 1'b0;
        end
        2'b01: begin  // Greater
            A_equal = 1'b0;
            A_greater = 1'b1;
            A_less = 1'b0;
        end
        default: begin  // Less (2'b00)
            A_equal = 1'b0;
            A_greater = 1'b0;
            A_less = 1'b1;
        end
    endcase
end

endmodule