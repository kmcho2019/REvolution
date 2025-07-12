module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;

always @(*) begin
    case(y)
        3'b000: Y1_next = w; // A
        3'b001: Y1_next = ~w; // B
        3'b010: Y1_next = ~w; // C
        3'b011: Y1_next = 1'b1; // D
        3'b100: Y1_next = w; // E
        3'b101: Y1_next = 1'b0; // F
        default: Y1_next = 1'b0;
    endcase
end

assign Y1 = Y1_next;

endmodule