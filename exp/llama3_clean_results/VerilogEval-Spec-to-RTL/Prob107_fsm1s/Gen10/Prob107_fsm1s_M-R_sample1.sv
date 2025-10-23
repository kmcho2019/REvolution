module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Current state
reg next_state; // Next state
wire state_b; // State B
wire state_a; // State A

assign state_b = ~state; // State B is represented by binary '0'
assign state_a = state; // State A is represented by binary '1'

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        state <= next_state; // Update state on rising edge of clock
    end
end

always @(*) begin
    if(state == 0) begin // Current state is B
        if(in == 0) begin
            next_state = 1; // Transition to A
        end else begin
            next_state = 0; // Stay in B
        end
    end else begin // Current state is A
        if(in == 0) begin
            next_state = 0; // Transition to B
        end else begin
            next_state = 1; // Stay in A
        end
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule