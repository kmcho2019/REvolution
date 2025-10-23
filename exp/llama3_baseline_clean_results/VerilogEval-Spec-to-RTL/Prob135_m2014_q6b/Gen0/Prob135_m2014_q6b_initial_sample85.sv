module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

reg Y1_next;

always @(*)
begin
    case (y)
        3'b000: Y1_next = w; // A to B (if w=1) or stay in A (if w=0)
        3'b001: Y1_next = ~w; // B to C (if w=0) or stay in B is not possible, B to D (if w=1)
        3'b010: Y1_next = ~w; // C to E (if w=1) or C to D (if w=0)
        3'b011: Y1_next = 1'b1; // D to F (if w=0) or D to A (if w=1), both result in y[1] being 1 in the next state
        3'b100: Y1_next = w; // E to D (if w=1) or stay in E (if w=0)
        3'b101: Y1_next = ~w; // F to C (if w=0) or F to D (if w=1)
        default: Y1_next = 1'b0; // default to 0 for unknown states
    endcase
end

always @(posedge w or posedge y)
begin
    Y1 <= Y1_next;
end

assign Y1 = y[1];

endmodule