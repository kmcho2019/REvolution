module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next-state logic for y[1]
wire y1_next;

always @(*) begin
    case (y)
        3'b000: y1_next = w; // A (0) --0--> B, A (0) --1--> A
        3'b001: y1_next = ~w; // B (0) --0--> C, B (0) --1--> D
        3'b010: y1_next = ~w; // C (0) --0--> E, C (0) --1--> D
        3'b011: y1_next = ~w; // D (0) --0--> F, D (0) --1--> A
        3'b100: y1_next = w; // E (1) --0--> E, E (1) --1--> D
        3'b101: y1_next = ~w; // F (1) --0--> C, F (1) --1--> D
    endcase
end

endmodule