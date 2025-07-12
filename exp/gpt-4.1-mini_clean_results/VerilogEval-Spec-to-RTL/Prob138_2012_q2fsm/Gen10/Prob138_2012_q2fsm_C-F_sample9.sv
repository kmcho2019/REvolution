module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding of states: only one bit set per state
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Condition for state update to reduce toggling and power
    wire state_change = (next_state != state);

    // Sequential logic: state register with synchronous active-high reset and conditional update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (state_change)
            state <= next_state;
    end

    // Next state combinational logic using case statement for clarity and synthesis efficiency
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

    // Output logic: z is 1 only in states E or F, continuous assignment for minimal complexity and power
    assign z = (state == E) || (state == F);

endmodule