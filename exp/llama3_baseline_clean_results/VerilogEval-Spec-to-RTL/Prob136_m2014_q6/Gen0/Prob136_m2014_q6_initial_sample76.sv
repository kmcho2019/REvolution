module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Enumerated type for states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Current state register
state_t state;
state_t next_state;

// Output z assignment
assign z = (state == E) || (state == F);

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        A: next_state = (w == 0) ? B : A;
        B: next_state = (w == 0) ? C : D;
        C: next_state = (w == 0) ? E : D;
        D: next_state = (w == 0) ? F : A;
        E: next_state = (w == 0) ? E : D;
        F: next_state = (w == 0) ? C : D;
        default: next_state = A;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule