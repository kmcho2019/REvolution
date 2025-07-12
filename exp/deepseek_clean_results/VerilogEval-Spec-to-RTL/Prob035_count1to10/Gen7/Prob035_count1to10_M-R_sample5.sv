module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = reset ? 4'b0001 :         // Reset condition
               (q[3] & q[1]) ? 4'b0001 :  // Wrap-around at 10 (1010)
               q + 4'b0001;               // Normal increment

always @(posedge clk) begin
    q <= next_q;
end

endmodule