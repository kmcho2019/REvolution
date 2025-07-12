module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

wire Y1_next;

assign Y1_next = (
    (y == 3'b001 && w) ||  // State B to State D
    (y == 3'b010 && w) ||  // State C to State D
    (y == 3'b011) ||      // State D
    (y == 3'b100) ||      // State E
    (y == 3'b101)         // State F
);

assign Y1 = y[1];

endmodule