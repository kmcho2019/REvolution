module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoding for states: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = A; // default to A (safe fallback)
        case (1'b1) // one-hot detection
            state[0]: next_state = (w == 1'b0) ? B : A;  // A
            state[1]: next_state = (w == 1'b0) ? C : D;  // B
            state[2]: next_state = (w == 1'b0) ? E : D;  // C
            state[3]: next_state = (w == 1'b0) ? F : A;  // D
            state[4]: next_state = (w == 1'b0) ? E : D;  // E
            state[5]: next_state = (w == 1'b0) ? C : D;  // F
            default:  next_state = A;                     // default fallback
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 in states E or F
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule