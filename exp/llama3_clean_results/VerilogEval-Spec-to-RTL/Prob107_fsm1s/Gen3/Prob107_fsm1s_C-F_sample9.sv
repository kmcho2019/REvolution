module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit variable to hold the state (0 or 1)
reg next_state;

// Directly assign the output based on the current state
assign out = (state == 1'b1)? 1'b1 : 1'b0;

// Combinational logic for next state calculation
always @(*) begin
    case(state)
        1'b0: next_state = (in == 1'b0)? 1'b1 : 1'b0;
        1'b1: next_state = (in == 1'b0)? 1'b0 : 1'b1;
    endcase
end

// Sequential logic for state register
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state 1
    end else begin
        state <= next_state;
    end
end

endmodule