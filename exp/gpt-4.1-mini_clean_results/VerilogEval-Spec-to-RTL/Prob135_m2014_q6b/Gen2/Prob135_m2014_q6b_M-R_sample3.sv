module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y1_next;

    // Next-state logic for y[1]
    assign y1_next = (y == 3'b001) ? 1'b1 :               // B: next y1=1
                     (y == 3'b010) ? (w ? 1'b1 : 1'b0) : // C: w=1->1, w=0->0
                     (y == 3'b100) ? (w ? 1'b1 : 1'b0) : // E: w=1->1, w=0->0
                     (y == 3'b101) ? 1'b1 :               // F: next y1=1
                     (y == 3'b000) ? 1'b0 :               // A: next y1=0
                     (y == 3'b011) ? 1'b0 :               // D: next y1=0
                     1'b0;                               // Default

    assign Y1 = y1_next;

endmodule