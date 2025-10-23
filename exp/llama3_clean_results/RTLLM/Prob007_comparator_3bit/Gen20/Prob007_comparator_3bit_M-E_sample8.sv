module comparator_3bit(
    input logic [2:0] A,
    input logic [2:0] B,
    output logic A_greater,
    output logic A_equal,
    output logic A_less
);

always @(*) begin
    case ({A, B})
        default: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 0;
        end
        {3'bxxx, 3'bxxx}: begin
            A_greater = (A > B) ? 1 : 0;
            A_equal = (A == B) ? 1 : 0;
            A_less = (A < B) ? 1 : 0;
        end
    endcase
end

endmodule