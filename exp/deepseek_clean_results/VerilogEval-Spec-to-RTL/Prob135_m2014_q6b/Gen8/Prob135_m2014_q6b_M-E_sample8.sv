module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

// Priority-encoded next-state logic for y[1]
assign y1_next = 
    (y == 3'b001) ? (~w) :          // State B: y[1] = 1 if w=0 (B→C), else 0 (B→A)
    (y == 3'b010) ? (w) :           // State C: y[1] = 1 if w=1 (C→D), else 0 (C→E)
    (y == 3'b011) ? (w) :           // State D: y[1] = 1 if w=1 (D→A), else 0 (D→F)
    (y == 3'b100) ? (w) :           // State E: y[1] = 1 if w=1 (E→D), else 0 (E→E)
    (y == 3'b101) ? 1'b1 :          // State F: y[1] always 1 (F→C or F→D)
    1'b0;                           // Default (State A): y[1] stays 0

endmodule