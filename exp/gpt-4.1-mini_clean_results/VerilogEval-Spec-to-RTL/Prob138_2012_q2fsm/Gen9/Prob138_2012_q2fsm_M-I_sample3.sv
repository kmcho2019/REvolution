module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding of states: one bit per state
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state; // Always update state without gating
    end

    // Combinational logic: next state logic
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;  // Safety fallback
        endcase
    end

    // Output logic: z is 1 in states E and F
    assign z = state[4] | state[5]; // E=bit4, F=bit5

endmodule