module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {B, A} current_state, next_state;

// Output logic based on the current state
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx;
    endcase
end

// State transition logic
always_comb begin
    case (current_state)
        B: case (in)
                1'b0: next_state = A;
                1'b1: next_state = B;
                default: next_state = 1'bx;
            endcase
        A: case (in)
                1'b0: next_state = B;
                1'b1: next_state = A;
                default: next_state = 1'bx;
            endcase
        default: next_state = 1'bx;
    endcase
end

// Synchronous reset and state update
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

endmodule