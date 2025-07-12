module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the next state logic using combinational logic
wire [2:0] next_state;
assign next_state = (a) ? 3'd4 : (q == 3'd6) ? 3'd0 : q + 1'd1;

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    q <= next_state;
end

endmodule