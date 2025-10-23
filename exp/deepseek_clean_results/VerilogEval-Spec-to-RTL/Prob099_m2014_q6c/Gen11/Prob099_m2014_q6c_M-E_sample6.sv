module TopModule(
    input [5:0] y,
    input w,
    output Y1,  // Next state y[0] (state A)
    output Y3   // Next state y[2] (state C)
);

    // Y1 is active only when transitioning from D to A (D with w=1)
    assign Y1 = y[3] & w;

    // Y3 is active when:
    // 1. Two-step transition A→B→C (A with w=0, then B with w=0)
    //    But since we're computing next state, we need current state B with w=0
    // 2. Current state F with w=0 (F→C)
    // Using a more optimized encoding:
    assign Y3 = (y[1] & ~w) |  // B→C
                (y[5] & ~w);   // F→C

    // Additional logic to handle the A→B→C path:
    // We need to track if we came from A to properly set Y3
    // This requires adding a temporary register
    reg came_from_A;
    always @(*) begin
        came_from_A = (y[0] & ~w);  // True if we're transitioning from A with w=0
    end

    // Modified Y3 assignment to include the A→B→C path
    assign Y3 = (y[1] & ~w & came_from_A) |  // B→C only if came from A
                (y[5] & ~w);                // F→C

endmodule