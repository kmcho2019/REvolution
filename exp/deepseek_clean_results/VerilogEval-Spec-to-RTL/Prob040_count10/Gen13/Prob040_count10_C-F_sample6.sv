module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    // Synchronous reset has priority, then check for terminal count (9=1001)
    q <= reset ? 4'b0000 : (q[3] & q[0]) ? 4'b0000 : q + 1;
end

endmodule