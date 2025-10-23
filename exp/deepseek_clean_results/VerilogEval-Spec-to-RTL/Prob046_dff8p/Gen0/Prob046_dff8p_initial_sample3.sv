module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'b00110100;  // Reset to 0x34
    end else begin
        q <= d;           // Pass input to output
    end
end

endmodule