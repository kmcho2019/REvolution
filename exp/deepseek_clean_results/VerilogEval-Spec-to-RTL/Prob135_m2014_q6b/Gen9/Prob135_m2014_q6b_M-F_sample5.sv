module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :               // A: stays 0 for all transitions
        (y == 3'b001) ? 1'b1 :               // B: both transitions set y[1]=1
        (y == 3'b010) ? (w ? 1'b1 : 1'b0) :  // C: w=0→E(0), w=1→D(1)
        (y == 3'b011) ? 1'b0 :               // D: both transitions set y[1]=0
        (y == 3'b100) ? (w ? 1'b1 : 1'b0) :  // E: w=0→E(0), w=1→D(1)
        (y == 3'b101) ? 1'b1 :               // F: both transitions set y[1]=1
        1'b0; // Default case (should never occur)

endmodule