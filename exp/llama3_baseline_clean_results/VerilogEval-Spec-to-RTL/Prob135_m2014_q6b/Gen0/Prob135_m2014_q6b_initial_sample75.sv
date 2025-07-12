module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;
assign Y1 = y[1];

always @(*) begin
    case(y)
        3'b000: Y1_next = w ? 0 : 0;  // A
        3'b001: Y1_next = w ? 0 : 0;  // B
        3'b010: Y1_next = w ? 1 : 0;  // C
        3'b011: Y1_next = w ? 1 : 1;  // D
        3'b100: Y1_next = w ? 1 : 1;  // E
        3'b101: Y1_next = w ? 1 : 0;  // F
        default: Y1_next = 1'b0;
    endcase
end

always @(*) begin
    Y1 = y[1];
end

endmodule