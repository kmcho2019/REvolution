module TopModule (
    input  [5:0] y,   // current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2,  // next-state bit for B (y[1])
    output       Y4   // next-state bit for D (y[3])
);

reg next_B, next_D;

always @(*) begin
    // Default next states off
    next_B = 1'b0;
    next_D = 1'b0;

    // Check which state is active and define next states for B and D per FSM
    if (y[0]) begin 
        // State A
        // A(0) --0--> B
        if (w == 1'b0)
            next_B = 1'b1;
        // A(1) --1--> A (no next_B or next_D)
    end else if (y[1]) begin
        // State B
        // B(0) --0--> C  (does not affect next_B or next_D)
        // B(0) --1--> D
        if (w == 1'b1)
            next_D = 1'b1;
    end else if (y[2]) begin
        // State C
        // C(0) --0--> E
        // C(0) --1--> D
        if (w == 1'b1)
            next_D = 1'b1;
    end else if (y[3]) begin
        // State D
        // D(0) --0--> F
        // D(0) --1--> A
        // No next_B or next_D since B is y[1], D is y[3], next is F or A
    end else if (y[4]) begin
        // State E
        // E(1) --0--> E
        // E(1) --1--> D
        if (w == 1'b1)
            next_D = 1'b1;
    end else if (y[5]) begin
        // State F
        // F(1) --0--> C
        // F(1) --1--> D
        if (w == 1'b1)
            next_D = 1'b1;
    end
end

assign Y2 = next_B;
assign Y4 = next_D;

endmodule