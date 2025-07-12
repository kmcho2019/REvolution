module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Reset value 0x34 = 8'b00110100
always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34;  // Clear hexadecimal notation for reset value
    end else begin
        q <= d;      // Normal operation
    end
end

endmodule