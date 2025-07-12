module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    // A = 6'b000001, B = 6'b000010, C = 6'b000100, D = 6'b001000, E = 6'b010000, F = 6'b100000
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Next state logic combinational block (one-hot next state)
    always @(*) begin
        // Default: hold state
        next_state = 6'b0;

        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic combinational: z = 1 when in state E or F
    assign z = current_state[E] | current_state[F];

endmodule