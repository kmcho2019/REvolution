module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q = 8'b0  // Explicit initialization
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset
    end else begin
        q <= d;     // Data capture
    end
end

endmodule