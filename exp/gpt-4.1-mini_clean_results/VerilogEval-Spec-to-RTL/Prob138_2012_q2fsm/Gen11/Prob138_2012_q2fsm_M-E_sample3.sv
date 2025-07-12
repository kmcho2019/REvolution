module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        // Default: no state active (should never happen)
        next_state = 6'b000000;

        case (1'b1)  // Priority encoded based on one-hot current state bits
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
                next_state = A;  // fallback safe state
        endcase
    end

    // Output logic: z = 1 when in states E or F
    assign z = state[4] | state[5];

endmodule