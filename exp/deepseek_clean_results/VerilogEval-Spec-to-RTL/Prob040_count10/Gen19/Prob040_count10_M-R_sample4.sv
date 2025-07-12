module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = reset ? 4'b0000 :          // Synchronous reset
                (q[3] & q[0]) ? 4'b0000 :  // Efficient check for 9 (1001)
                q + 1'b1;                  // Normal increment

always @(posedge clk) begin
    q <= next_q;
end

endmodule