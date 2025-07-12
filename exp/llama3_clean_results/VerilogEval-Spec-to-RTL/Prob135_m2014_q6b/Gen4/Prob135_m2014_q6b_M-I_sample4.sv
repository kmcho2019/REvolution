module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: Y1 = (w == 1'b0)? 1'b0 : 1'b0; // State A
        3'b001: Y1 = (w == 1'b0)? 1'b0 : 1'b1; // State B
        3'b010: Y1 = (w == 1'b0)? 1'b1 : 1'b1; // State C
        3'b011: Y1 = (w == 1'b0)? 1'b1 : 1'b0; // State D
        3'b100: Y1 = (w == 1'b0)? 1'b1 : 1'b0; // State E
        3'b101: Y1 = (w == 1'b0)? 1'b0 : 1'b1; // State F
    endcase
end

endmodule