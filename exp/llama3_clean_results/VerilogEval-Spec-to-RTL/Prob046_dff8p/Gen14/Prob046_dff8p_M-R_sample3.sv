// Refactored TopModule with a single always block
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34; // Reset to 0x34
    end else begin
        q <= d; // Assign d to q on the negative edge of clk
    end
end

endmodule