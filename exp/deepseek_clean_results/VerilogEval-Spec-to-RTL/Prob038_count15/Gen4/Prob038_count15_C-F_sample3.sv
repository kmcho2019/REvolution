module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// 4-bit binary counter with synchronous reset
// Counts from 0 to 15 (inclusive) then wraps around
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset to 0
    end
    else begin
        q <= q + 4'b0001;  // Increment with explicit 4-bit constant
    end
end

endmodule