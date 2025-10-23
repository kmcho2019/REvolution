module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Next-state logic using one-hot encoding and combinational logic
    always @(*) begin
        // Default next_state to 0 (no state)
        next_state = 6'b0;
        case (1'b1) // one-hot decode current state
            state[A]: next_state = w ? B : A;
            state[B]: next_state = w ? C : D;
            state[C]: next_state = w ? E : D;
            state[D]: next_state = w ? F : A;
            state[E]: next_state = w ? E : D;
            state[F]: next_state = w ? C : D;
            default: next_state = A;  // safe default
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z = 1 when in state E or F
    assign z = state[E] | state[F];

endmodule