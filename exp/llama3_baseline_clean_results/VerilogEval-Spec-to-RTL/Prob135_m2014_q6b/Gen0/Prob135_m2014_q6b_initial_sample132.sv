module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
always @(y, w) begin
    case (y)
        3'b000: Y1 = w;  // A: y[1] = 0, next y[1] = w (A -> A or A -> B)
        3'b001: Y1 = ~w; // B: y[1] = 0, next y[1] = ~w (B -> C or B -> D)
        3'b010: Y1 = ~w; // C: y[1] = 0, next y[1] = ~w (C -> E or C -> D)
        3'b011: Y1 = ~w; // D: y[1] = 1, next y[1] = ~w (D -> F or D -> A)
        3'b100: Y1 = w;  // E: y[1] = 1, next y[1] = w (E -> E or E -> D)
        3'b101: Y1 = ~w; // F: y[1] = 1, next y[1] = ~w (F -> C or F -> D)
        default: Y1 = 1'b0; // Default case
    endcase
end

endmodule