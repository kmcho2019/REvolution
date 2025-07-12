module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using one-hot encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable
reg next_state; // Next state variable

// Combinational logic for next state, simplified
always @(*) begin
    case(state)
        STATE_B: next_state = in? STATE_B : STATE_A;
        STATE_A: next_state = in? STATE_A : STATE_B;
        default: next_state = STATE_B; // Default state
    endcase
end

// Sequential logic for state update, remains the same
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Output logic remains direct and simple
assign out = ~state; // Output directly related to the state

endmodule