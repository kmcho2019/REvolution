module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Combinational logic for next state
assign next_state = state ^ (a ^ b);

// Combinational logic for output q
assign q = state ^ b;

// Sequential logic to update state on positive clock edge
always @(posedge clk) begin
    state <= next_state;
end

// Initialization for simulation purposes
initial begin
    state = 1'b0;
end

endmodule