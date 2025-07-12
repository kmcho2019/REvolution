module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// State flip-flops
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always_comb begin
    case(state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // Default to state A for any unexpected state
    endcase
end

// Continuous assignment for output z
assign z = (state == E || state == F) ? 1'b1 : 1'b0;

endmodule