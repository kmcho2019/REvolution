module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = (q == 4'd9) ? 4'd0 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;           // Synchronous active-high reset
    else
        q <= next_q;         // Load next state (count or wrap)
end

endmodule