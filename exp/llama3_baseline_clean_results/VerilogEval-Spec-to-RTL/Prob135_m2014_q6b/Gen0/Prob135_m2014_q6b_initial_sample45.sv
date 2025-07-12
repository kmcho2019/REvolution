module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// next-state logic for y[1]
reg next_y1;
always @(*) begin
    case (y)
        3'b000: next_y1 = w; // A (0) --1--> A
        3'b001: next_y1 = w; // B (0) --1--> D
        3'b010: next_y1 = w; // C (0) --1--> D
        3'b011: next_y1 = 1'b1; // D (0) --0--> F, D (0) --1--> A
        3'b100: next_y1 = 1'b1; // E (1) --0--> E, E (1) --1--> D
        3'b101: next_y1 = 1'b1; // F (1) --0--> C, F (1) --1--> D
        default: next_y1 = 1'b0;
    endcase
end

// output logic
assign Y1 = y[1];

endmodule