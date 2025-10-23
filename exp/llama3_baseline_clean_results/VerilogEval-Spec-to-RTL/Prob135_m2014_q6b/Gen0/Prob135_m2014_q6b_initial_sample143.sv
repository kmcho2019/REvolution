module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

reg Y1_next;

always @(*) begin
    case (y)
        3'b000: Y1_next = w; // A to B or A to A
        3'b001: Y1_next = ~w; // B to D or B to C
        3'b010: Y1_next = ~w; // C to D or C to E
        3'b011: Y1_next = 1'b0; // D to A or D to F
        3'b100: Y1_next = ~w; // E to D or E to E
        3'b101: Y1_next = ~w; // F to D or F to C
        default: Y1_next = 1'b0; // default case
    endcase
end

always @(posedge w or posedge y) begin
    Y1 <= Y1_next;
end

assign Y1 = y[1];

endmodule