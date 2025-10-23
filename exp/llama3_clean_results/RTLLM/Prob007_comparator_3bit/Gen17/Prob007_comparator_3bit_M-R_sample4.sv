module comparator_3bit(
    input logic [2:0] A,
    input logic [2:0] B,
    output logic A_greater,
    output logic A_equal,
    output logic A_less
);

always @(*) begin
    case (1'b1)
        (A > B): begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
        (A == B): begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end
        default: begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end
    endcase
end

endmodule