module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Simplified decade counter (0-9) with synchronous reset
always @(posedge clk) begin
    q <= reset ? 0 : (q == 9) ? 0 : q + 1;
end

endmodule