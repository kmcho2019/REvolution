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

wire y1_next;

assign y1_next = 
    (y == A) ? 1'b0 :  // A→A or A→B → y[1]=0
    (y == B) ? 1'b1 :  // B→D or B→C → y[1]=1
    (y == C) ? (w ? 1'b1 : 1'b0) :  // C→D(1) or C→E(0)
    (y == D) ? (w ? 1'b0 : 1'b0) :  // D→A(0) or D→F(0)
    (y == E) ? (w ? 1'b1 : 1'b0) :  // E→D(1) or E→E(0)
    (y == F) ? (w ? 1'b1 : 1'b1) :  // F→D(1) or F→C(1)
    1'b0;

assign Y1 = y[1];

endmodule