module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Define the next state logic
wire [3:0] next_q;
assign next_q = (reset) ? 4'd0 : (q + 1);

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    q <= next_q;
end

endmodule