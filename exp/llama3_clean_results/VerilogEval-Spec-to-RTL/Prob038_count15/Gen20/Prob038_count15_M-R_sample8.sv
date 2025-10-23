module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Combinational logic to calculate the next state
wire [3:0] next_q;
assign next_q = (q == 4'd15) ? 4'd0 : q + 1'd1;

// Sequential logic to update the state based on the clock and reset
always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= next_q;
    end
end

endmodule