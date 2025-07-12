module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire counter_reset = q[3] & q[0];  // Detect 9 (1001)

assign next_q = reset ? 4'b0000 : 
               counter_reset ? 4'b0000 : q + 1;

always @(posedge clk) begin
    q <= next_q;
end

endmodule