module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next-state logic for y[1]
always @(*) begin
    case (y)
        3'b000: Y1 = w ? 0 : 0;  // A
        3'b001: Y1 = w ? 0 : 0;  // B
        3'b010: Y1 = w ? 1 : 1;  // C
        3'b011: Y1 = w ? 1 : 1;  // D
        3'b100: Y1 = w ? 1 : 1;  // E
        3'b101: Y1 = w ? 1 : 1;  // F
        default: Y1 = 1'bx;
    endcase
end

endmodule