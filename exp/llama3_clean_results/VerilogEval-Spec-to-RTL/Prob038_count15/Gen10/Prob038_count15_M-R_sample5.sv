module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Combinational logic to determine the next state
wire [3:0] next_q;
assign next_q = (reset) ? 4'd0 : (q == 4'd15) ? 4'd0 : q + 1'd1;

// Sequential logic to update the current state
always @(posedge clk) begin
    q <= next_q;
end

endmodule