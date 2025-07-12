module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = reset ? 4'b0001 :   // Reset condition
               q[3] ? 4'b0001 :     // Simplified wrap-around at 10 (only check q[3])
               q + 4'b0001;         // Normal increment

always @(posedge clk) begin
    q <= next_q;
end

endmodule