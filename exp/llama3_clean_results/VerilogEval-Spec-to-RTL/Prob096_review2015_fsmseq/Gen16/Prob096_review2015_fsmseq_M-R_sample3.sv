module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state; // Using 4 bits to encode 5 states (0 to 4)
assign start_shifting = (state == 4'b100); // Set start_shifting to 1 when in the final state

// Combinational logic for next state using assign
reg [3:0] next_state;
assign next_state = (reset) ? 4'b000 : // Reset condition
                    (state == 4'b000 && data) ? 4'b001 : // State 0 to 1
                    (state == 4'b001 && data) ? 4'b010 : // State 1 to 2
                    (state == 4'b010 && ~data) ? 4'b011 : // State 2 to 3
                    (state == 4'b011 && data) ? 4'b100 : // State 3 to 4 (final state)
                    (state == 4'b100) ? 4'b100 : // Remain in final state
                    4'b000; // Default to state 0 for other transitions

// Synchronous update of state
always @(posedge clk) begin
    if(reset) begin
        state <= 4'b000;
    end else begin
        state <= next_state;
    end
end

endmodule