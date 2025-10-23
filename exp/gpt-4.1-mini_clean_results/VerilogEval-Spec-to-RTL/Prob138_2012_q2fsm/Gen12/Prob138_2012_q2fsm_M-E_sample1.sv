module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding: each bit represents a state
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state registers with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic based on current state and input w
    always @(*) begin
        // Default no state active (should never happen)
        next_state = 6'b000000;

        case (1'b1)  // one-hot encoded state detected by priority encoder style
            state[0]: // A
                next_state = w ? B : A;
            state[1]: // B
                next_state = w ? C : D;
            state[2]: // C
                next_state = w ? E : D;
            state[3]: // D
                next_state = w ? F : A;
            state[4]: // E
                next_state = w ? E : D;
            state[5]: // F
                next_state = w ? C : D;
            default:
                next_state = A; // Recover to initial state on invalid encoding
        endcase
    end

    // Output logic: z is 1 when state is E or F
    assign z = state[4] | state[5];

endmodule