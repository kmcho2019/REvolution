module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: // A
            Y1 = w ? 1'b0 : 1'b0;
        3'b001: // B
            Y1 = w ? 1'b1 : 1'b1;
        3'b010: // C
            Y1 = w ? 1'b1 : 1'b1;
        3'b011: // D
            Y1 = w ? 1'b0 : 1'b0;
        3'b100: // E
            Y1 = w ? 1'b1 : 1'b1;
        3'b101: // F
            Y1 = w ? 1'b1 : 1'b0;
        default:
            Y1 = 1'b0;
    endcase
end

endmodule