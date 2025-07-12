module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;

always @(*) begin
    case (y)
        3'b000: Y1_next = w; // A
        3'b001: Y1_next = w; // B
        3'b010: Y1_next = 1'b0; // C
        3'b011: Y1_next = 1'b1; // D
        3'b100: Y1_next = 1'b1; // E
        3'b101: Y1_next = 1'b1; // F
        default: Y1_next = 1'b0;
    endcase
end

always @(posedge y) begin
    Y1 <= Y1_next;
end

assign Y1 = y[1];

endmodule