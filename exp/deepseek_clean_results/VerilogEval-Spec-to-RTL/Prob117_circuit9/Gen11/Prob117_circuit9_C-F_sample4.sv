module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    q <= a ? 3'd4 :          // synchronous reset to 4 when a=1
         (q == 3'd6) ? 3'd0 : // wrap around to 0 after 6
         q + 3'd1;           // otherwise increment
end

endmodule