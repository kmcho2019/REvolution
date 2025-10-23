module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Combinational logic for next state
always @(*) begin
    if (~a & b)
        next_state = 1'b1;
    else if (a & b)
        next_state = ~state;
    else
        next_state = 1'b0;
end

// Sequential state update
always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

// Initialize state for simulation
initial begin
    state = 1'b0;
end

endmodule