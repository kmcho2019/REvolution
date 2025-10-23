module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Parameterized state encoding for readability and scalability
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

// Parameterized reset state for flexibility
localparam RESET_STATE = STATE_B;

reg state; // Current state
reg next_state; // Next state

// Combinational logic for next state
always @(*) begin
    case(state)
        STATE_B: next_state = in ? STATE_B : STATE_A;
        STATE_A: next_state = in ? STATE_A : STATE_B;
        default: next_state = RESET_STATE; // Default to reset state
    endcase
end

// Sequential logic for state update with non-blocking assignments
always @(posedge clk) begin
    if(reset) begin
        state <= RESET_STATE; // Reset to the defined reset state
    end else begin
        state <= next_state;
    end
end

// Output logic based on state, separate and clear
assign out = ~state; // Directly relates output to state for simplicity

endmodule