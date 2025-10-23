module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

wire toggle_enable = (out & k) | (~out & j);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 1'b0;  // Reset to OFF state
    end else if (toggle_enable) begin
        out <= ~out;  // Toggle state when enabled
    end
end

endmodule