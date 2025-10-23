module TopModule (
    input clk,
    input d,
    output reg q
);

reg last_d;
wire clk_en;
wire gated_clk;

// Detect when input changes
assign clk_en = (d != last_d);

// Clock gating cell
assign gated_clk = clk & clk_en;

// Main flip-flop
always @(posedge gated_clk) begin
    q <= d;
end

// Track previous input value
always @(posedge clk) begin
    last_d <= d;
end

endmodule