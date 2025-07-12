module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        // Default next state to current state to avoid latches
        next_state = state;

        case (1'b1)  // Priority encoding style for one-hot states
            state[A]: next_state = (w == 0) ? B : A;
            state[B]: next_state = (w == 0) ? C : D;
            state[C]: next_state = (w == 0) ? E : D;
            state[D]: next_state = (w == 0) ? F : A;
            state[E]: next_state = (w == 0) ? E : D;
            state[F]: next_state = (w == 0) ? C : D;
            default:  next_state = A; // Recovery from invalid states
        endcase
    end

    // Output logic
    always @(*) begin
        // z = 1 if in states E or F
        z = (state == E) || (state == F);
    end

endmodule