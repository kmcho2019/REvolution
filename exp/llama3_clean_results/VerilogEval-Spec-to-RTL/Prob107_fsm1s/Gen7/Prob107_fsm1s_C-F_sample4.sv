module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// State register
reg state;

// Output assignment based on current state
assign out = (state == 1'b0); // Out is 1 in state B (0) and 0 in state A (1)

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        // Synchronous reset to state B (0)
        state <= 1'b0;
    end else begin
        // State transitions based on current state and input
        state <= (state == 1'b0) ? ~in : in;
    end
end

endmodule