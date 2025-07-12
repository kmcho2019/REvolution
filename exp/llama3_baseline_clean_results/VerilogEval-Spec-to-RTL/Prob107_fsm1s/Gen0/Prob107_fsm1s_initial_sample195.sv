module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum {B, A} current_state, next_state;

// Combinational logic to determine next state
always_comb begin
    case (current_state)
        B: next_state = (in == 1'b0) ? A : B;
        A: next_state = (in == 1'b0) ? B : A;
        default: next_state = B; // Default to B
    endcase
end

// Sequential logic to update state
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default to 1 for state B
    endcase
end

endmodule