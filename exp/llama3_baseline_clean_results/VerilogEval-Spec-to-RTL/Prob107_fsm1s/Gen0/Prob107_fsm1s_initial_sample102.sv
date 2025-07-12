module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
enum logic [0:0] {B, A} state, next_state;

// Output logic based on current state
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // Unknown state, should not happen
    endcase
end

// State transitions
always_comb begin
    case(state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B; // Unknown state, default to B
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule