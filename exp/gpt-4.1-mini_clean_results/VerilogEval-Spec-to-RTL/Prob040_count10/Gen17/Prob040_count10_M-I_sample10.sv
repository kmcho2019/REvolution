module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;                   // Synchronous active-high reset
    else
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;  // Increment with wrap-around
end

endmodule