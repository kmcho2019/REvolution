module TopModule (
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case ({y[2], y[1], y[0]})
        3'b000: // State A
            Y1 = w ? 0 : 0;
        3'b001: // State B
            Y1 = w ? 1 : 0;
        3'b010: // State C
            Y1 = w ? 1 : 0;
        3'b011: // State D
            Y1 = w ? 0 : 1;
        3'b100: // State E
            Y1 = w ? 1 : 1;
        3'b101: // State F
            Y1 = w ? 1 : 0;
        default:
            Y1 = 0;
    endcase
end

endmodule