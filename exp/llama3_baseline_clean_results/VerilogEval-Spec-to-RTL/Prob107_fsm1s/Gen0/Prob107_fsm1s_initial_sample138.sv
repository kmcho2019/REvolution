module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {B, A} state, next_state;

// Output is determined by the state
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // Invalid state, set output to unknown
    endcase
end

// State transition logic
always_comb begin
    case(state)
        B: begin
            if (~in) next_state = A;
            else next_state = B;
        end
        A: begin
            if (~in) next_state = B;
            else next_state = A;
        end
        default: next_state = B; // Invalid state, default to B
    endcase
end

// Synchronous reset
always_ff @(posedge clk) begin
    if (reset) state <= B;
    else state <= next_state;
end

endmodule