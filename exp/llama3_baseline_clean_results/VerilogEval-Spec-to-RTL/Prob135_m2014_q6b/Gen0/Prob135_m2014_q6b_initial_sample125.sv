module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;

always @(*) begin
    case (y)
        3'b000: Y1_next = w; // A (0) --1--> A
        3'b001: Y1_next = w; // B (0) --1--> D
        3'b010: Y1_next = w; // C (0) --1--> D
        3'b011: Y1_next = w; // D (0) --1--> A
        3'b100: Y1_next = w; // E (1) --1--> D
        3'b101: Y1_next = w; // F (1) --1--> D
        default: Y1_next = 0;
    endcase
end

always @(posedge w or posedge y) begin
    Y1 <= Y1_next;
end

assign Y1 = y[1];

endmodule