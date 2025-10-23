module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State definitions (one-hot encoding)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Next state logic for Y1 (y[1] - state B)
    // Active only when in state A and w=1
    assign Y1 = (y == A) & w;

    // Next state logic for Y3 (y[3] - state D)
    // Active when:
    // 1. In state B and w=0
    // 2. In state C and w=0
    // 3. In state F and w=1
    // Optimized to: ~(w | y[0] | y[3])
    assign Y3 = ~(w | y[0] | y[3]);

endmodule