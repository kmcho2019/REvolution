module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34;  // Synchronous reset to 0x34
    end else begin
        q <= d;      // Normal operation
    end
end

endmodule