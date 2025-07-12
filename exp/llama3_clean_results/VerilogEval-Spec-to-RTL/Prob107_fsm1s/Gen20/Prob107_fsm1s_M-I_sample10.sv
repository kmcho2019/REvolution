module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable
reg next_state; // Next state variable

// Simplified combinational logic for next state
always @(*) begin
    case(state)
        STATE_B: next_state = in ? STATE_B : STATE_A;
        STATE_A: next_state = in ? STATE_A : STATE_B;
        default: next_state = STATE_B; // Default state
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Output logic
assign out = (state == STATE_B) ? 1'b1 : 1'b0;

endmodule