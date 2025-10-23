module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Only transition is from state A (y[0]) when w=1
    assign Y1 = (y == 6'b000001) & w;

    // Y3: Next state for y[3] (state D)
    // Priority-based transition logic:
    // 1. From state B (y[1]) when w=0
    // 2. From state C (y[2]) when w=0
    // 3. From state E (y[4]) when w=0
    // 4. From state F (y[5]) when w=0
    assign Y3 = (~w) & (
        (y == 6'b000010) |  // From B
        (y == 6'b000100) |  // From C
        (y == 6'b010000) |  // From E
        (y == 6'b100000)    // From F
    );

endmodule