module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states of the FSM
reg [2:0] state;
reg [2:0] next_state;

// Initialize the state
initial state = 4;

// Combinational logic to determine the next state
assign next_state = (a)? 4 : (state == 6)? 0 : state + 1;

// Update the state at every positive edge of the clock
always @(posedge clk) begin
    state <= next_state;
    q <= next_state;
end

endmodule