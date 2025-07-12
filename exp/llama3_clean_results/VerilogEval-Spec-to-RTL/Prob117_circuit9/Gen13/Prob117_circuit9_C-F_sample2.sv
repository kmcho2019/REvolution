module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Combinational logic to calculate the next state
wire [2:0] next_q;
assign next_q = (a) ? 4 : ((q < 6) ? (q + 1) : 0);

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    q <= next_q;
end

// Initialize the output
initial q = 4;

endmodule