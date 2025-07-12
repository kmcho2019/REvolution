module TopModule (
    input  wire [5:0] y,    // One-hot encoded current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input  wire       w,    // FSM input
    output wire       Y1,   // Next-state input for flip-flop y[1] (state B)
    output wire       Y3    // Next-state input for flip-flop y[3] (state D)
);

    // State indices for readability
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;
    localparam E = 4;
    localparam F = 5;

    // Next-state input for y[1] (B) comes only from A on input w=1
    assign Y1 = y[A] & w;

    // Next-state input for y[3] (D) comes from B, C, E, or F on input w=0
    assign Y3 = (~w) & (y[B] | y[C] | y[E] | y[F]);

endmodule