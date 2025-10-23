module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding - 3-bit binary
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // Sequential logic: synchronous active-high reset, state register updates unconditionally every clock cycle
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next-state logic with default assignment to prevent latches
    always @(*) begin
        next_state = state; // default hold state
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

    // Output logic: z=1 only in states E (4) and F (5)
    // Use minimal combinational expression checking state bits for better area and timing
    assign z = (state[2] & ~state[1]);

endmodule