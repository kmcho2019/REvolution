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

// Sequential logic for state update, simplified
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        // Simplified next state logic
        state <= (state == STATE_B && ~in) ? STATE_A :
                 (state == STATE_A && ~in) ? STATE_B : state;
    end
end

// Output logic remains direct and simple
assign out = ~state; // Output directly related to the state

endmodule