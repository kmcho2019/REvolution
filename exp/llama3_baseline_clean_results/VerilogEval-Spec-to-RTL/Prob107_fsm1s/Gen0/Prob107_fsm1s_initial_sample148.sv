module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states as an enum
enum logic [0:0] {B, A} state, next_state;

// Initial state is B
initial state = B;

// Combinational logic to determine next state
always_comb begin
    case (state)
        B: next_state = (in == 1'b0) ? A : B;
        A: next_state = (in == 1'b0) ? B : A;
        default: next_state = B; // Default to state B
    endcase
end

// Sequential logic for state register with reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Output logic, depends on the current state
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default output is 1 (state B's output)
    endcase
end

endmodule