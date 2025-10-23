module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Clock gating: gated clock only toggles when counting is enabled
wire gated_clk = clk & valid_count;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (out == 4'd11)
        out <= 4'b0000;
    else
        out <= out + 1'b1;
end

// Hold output when counting disabled by retaining value on posedge clk
// No need for explicit logic here as register updates only occur on gated_clk edges

endmodule