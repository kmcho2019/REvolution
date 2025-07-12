module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = reset ? 4'b0001 :        // Highest priority: reset
               (q[3] & q[1]) ? 4'b0001 : // Next priority: wrap at 10
               q + 1;                    // Default: increment

always @(posedge clk) begin
    q <= next_q;
end

endmodule