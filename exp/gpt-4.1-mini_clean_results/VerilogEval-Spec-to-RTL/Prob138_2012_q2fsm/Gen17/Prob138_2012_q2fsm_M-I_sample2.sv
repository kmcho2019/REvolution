module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding for 6 states (bit0 to bit5)
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: synchronous active-high reset, state register updates every clock cycle
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default hold
        casez (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // Output z: high in states E or F
    assign z = state[4] | state[5];

endmodule