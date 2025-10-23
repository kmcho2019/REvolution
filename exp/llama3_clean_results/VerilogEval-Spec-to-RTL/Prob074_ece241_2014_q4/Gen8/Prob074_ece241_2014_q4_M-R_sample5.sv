module TopModule(
    input clk,
    input x,
    output reg z
);

reg [2:0] state;
reg [2:0] next_state;

// Combinational logic for gate outputs
assign next_state[0] = x ^ state[0];
assign next_state[1] = x & ~state[1];
assign next_state[2] = x | ~state[2];

// Sequential logic for updating state
always @(posedge clk) begin
    state <= next_state;
end

// Combinational logic for computing z
assign z = ~(state[0] | state[1] | state[2]);

// Initial condition
initial begin
    state = 0;
end

endmodule