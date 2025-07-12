module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize q to 4 as per the problem statement
initial q = 4;

// Combinational logic to calculate the next state
wire [2:0] next_q;
assign next_q = (a) ? 4 : ((q == 6) ? 0 : (q + 1));

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    q <= next_q;
end

endmodule