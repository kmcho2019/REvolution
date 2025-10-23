module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Output out is 1 when the state machine is in the ON state
assign out = (state == ON) ? 1'b1 : 1'b0;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        OFF: next_state = (j == 1'b1) ? ON : OFF;
        ON:  next_state = (k == 1'b1) ? OFF : ON;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule