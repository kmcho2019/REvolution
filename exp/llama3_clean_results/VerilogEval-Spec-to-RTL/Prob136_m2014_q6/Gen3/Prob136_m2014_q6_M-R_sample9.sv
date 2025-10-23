module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
logic [5:0] currentState;
logic [5:0] nextState;

// One-hot encoding for states
assign nextState[0] = (currentState[0] && !w) || (currentState[3] && w);
assign nextState[1] = (currentState[0] && w);
assign nextState[2] = (currentState[1] && !w);
assign nextState[3] = (currentState[1] && w) || (currentState[2] && w) || (currentState[4] && w) || (currentState[5] && w);
assign nextState[4] = (currentState[2] && !w) && w;
assign nextState[5] = (currentState[3] && !w);

// Output z is 1 when the state machine is in state E or F
assign z = currentState[4] || currentState[5];

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b1;
    end else begin
        currentState <= nextState;
    end
end

endmodule