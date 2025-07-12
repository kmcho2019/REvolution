module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

parameter STATE_B = 0, STATE_A = 1;
reg state; // Current state
wire next_state;

// Combinational logic to determine next state and output
assign next_state = (state == STATE_B && in == 0) ? STATE_A :
                    (state == STATE_B && in == 1) ? STATE_B :
                    (state == STATE_A && in == 0) ? STATE_B :
                    STATE_A;
assign out = (state == STATE_B) ? 1'b1 : 1'b0;

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        state <= STATE_B; // Reset state is B
    end else begin
        state <= next_state;
    end
end

endmodule