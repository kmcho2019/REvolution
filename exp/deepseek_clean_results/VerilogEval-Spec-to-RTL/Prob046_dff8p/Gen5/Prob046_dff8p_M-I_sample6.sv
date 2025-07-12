module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VAL = 8'h34;

// Optional clock gating control (uncomment if needed)
// input enable;
// wire gated_clk = clk & enable;

always @(negedge clk /* or negedge gated_clk if using clock gating */) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule