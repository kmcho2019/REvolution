module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable
reg next_state; // Next state variable

// Combinational logic for next state, simplified
always @(*) begin
    next_state = (state == 1'b0) ? (~in) : in;
end

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Output logic remains direct and simple
always @(*) begin
    out = ~state; // Output directly related to the state
end

endmodule