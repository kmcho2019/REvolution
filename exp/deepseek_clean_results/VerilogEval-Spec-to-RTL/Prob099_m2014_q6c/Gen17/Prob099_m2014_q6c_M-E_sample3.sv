module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (state A)
    output Y3      // Next state y[2] (state C)
);

    // State definitions
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Next state A (Y1) logic:
    // Active when current state is D or F and w=1
    assign Y1 = ((y == D) || (y == F)) && w;

    // Next state C (Y3) logic:
    // Active when:
    // 1. Current state is B and w=0, or
    // 2. Current state is F and w=0
    assign Y3 = ((y == B) || (y == F)) && ~w;

endmodule