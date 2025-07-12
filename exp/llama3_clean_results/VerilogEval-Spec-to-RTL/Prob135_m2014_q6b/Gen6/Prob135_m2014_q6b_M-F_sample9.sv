module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: Y1 = w; // From A, next state is B if w is 1
        3'b001: Y1 = w; // From B, next state is D if w is 1, C if w is 0
        3'b010: Y1 = ~w; // From C, next state is E if w is 1, D if w is 0
        3'b011: Y1 = ~w; // From D, next state is A if w is 1, F if w is 0
        3'b100: Y1 = w; // From E, next state is D if w is 1, E if w is 0
        3'b101: Y1 = ~w; // From F, next state is C if w is 1, D if w is 0
        default: Y1 = 1'b0;
    endcase
end

endmodule