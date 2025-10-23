module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next state logic for y[1]
// Since we are only implementing the next-state logic for y[1], 
// we don't need to assign values to y[0] or y[2]
always @(*) begin
    case(y)
        3'b000: Y1 = w ? 0 : 0; // A (0) --0--> B, A (0) --1--> A
        3'b001: Y1 = w ? 0 : 0; // B (0) --0--> C, B (0) --1--> D
        3'b010: Y1 = w ? 0 : 0; // C (0) --0--> E, C (0) --1--> D
        3'b011: Y1 = w ? 0 : 1; // D (0) --0--> F, D (0) --1--> A
        3'b100: Y1 = w ? 1 : 1; // E (1) --0--> E, E (1) --1--> D
        3'b101: Y1 = w ? 1 : 0; // F (1) --0--> C, F (1) --1--> D
        default: Y1 = 1'bx;
    endcase
end

endmodule