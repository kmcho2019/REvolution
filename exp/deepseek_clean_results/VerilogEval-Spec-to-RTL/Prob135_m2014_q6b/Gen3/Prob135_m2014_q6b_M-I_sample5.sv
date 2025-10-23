module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// State definitions
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Next-state logic for y[1]
reg y1_next;
always @(*) begin
    case (y)
        A: y1_next = w ? 1'b0 : 1'b0;  // A->A (0) or A->B (0)
        B: y1_next = w ? 1'b1 : 1'b1;  // B->D (1) or B->C (1)
        C: y1_next = w ? 1'b1 : 1'b1;  // C->D (1) or C->E (1)
        D: y1_next = w ? 1'b0 : 1'b1;  // D->A (0) or D->F (1)
        E: y1_next = w ? 1'b1 : 1'b1;  // E->D (1) or E->E (1)
        F: y1_next = w ? 1'b1 : 1'b0;  // F->D (1) or F->C (0)
        default: y1_next = 1'b0;
    endcase
end

assign Y1 = y[1];

endmodule