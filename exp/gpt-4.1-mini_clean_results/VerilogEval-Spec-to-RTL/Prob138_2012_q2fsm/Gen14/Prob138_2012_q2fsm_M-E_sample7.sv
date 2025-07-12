module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001,
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

    // Next-state logic (combinational)
    always @(*) begin
        // Default: stay in current state
        next_state = 6'b0;

        case (1'b1) // one-hot encoded current state, find which bit is 1
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
                next_state = A; // safe fallback
        endcase
    end

    // Output logic: z=1 for states E and F
    assign z = state[4] | state[5];

endmodule