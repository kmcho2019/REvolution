module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states as an enum
enum logic {B = 0, A = 1} state, next_state;

always @(*) begin
    // Combinational logic for next state
    case(state)
        B: next_state = (in == 0)? A : B;
        A: next_state = (in == 0)? B : A;
        default: next_state = B; // Default to reset state
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        // Synchronous reset
        state <= B;
    end else begin
        // Update current state
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        B: out = 1;
        A: out = 0;
        default: out = 1; // Default to output of reset state
    endcase
end

endmodule