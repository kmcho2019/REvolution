module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 states)
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic using one-hot encoding
    always @(*) begin
        // default next_state is none active
        next_state = 6'b000000;

        case (state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;  // safe default
        endcase
    end

    // Output logic: z is high only in states E or F
    assign z = state[4] | state[5];

endmodule