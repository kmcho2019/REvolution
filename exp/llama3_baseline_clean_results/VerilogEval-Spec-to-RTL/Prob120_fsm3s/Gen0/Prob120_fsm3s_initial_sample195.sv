module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       out
);

// Enumerate states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

state_t current_state, next_state;

// Output logic based on current state
assign out = (current_state == D) ? 1'b1 : 1'b0;

// State transition logic
always_comb begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A; // Default to A if none of the above
    endcase
end

// Synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule