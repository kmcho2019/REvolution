module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire q_is_9 = (q[3] & ~q[2] & q[1] & q[0]); // Detect decimal 9 (1001)

wire [3:0] next_q = q_is_9 ? 4'd0 : q + 4'd1;

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule