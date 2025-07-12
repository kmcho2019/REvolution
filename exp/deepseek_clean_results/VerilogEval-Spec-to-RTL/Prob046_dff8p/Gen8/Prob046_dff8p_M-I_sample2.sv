module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] d_prev;
reg clk_en;
wire gated_clk;

assign gated_clk = clk & clk_en;

always @(negedge gated_clk) begin
    if (reset) begin
        q <= 8'h34;  // Hardcoded reset value
    end else begin
        q <= d;
    end
end

always @(posedge clk) begin
    d_prev <= d;
    clk_en <= (d != d_prev) | reset;  // Enable clock only when data changes or during reset
end

endmodule