module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // 3-bit binary encoding for six states
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // Sequential logic: synchronous active-high reset, unconditional state update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state determination
    always @(*) begin
        // Default assignment to hold state to prevent latches
        next_state = state;
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic: z = 1 for states E (100) and F (101)
    // Both have bit2=1 and bit1=0 -> z = state[2] & ~state[1]
    assign z = state[2] & ~state[1];

endmodule