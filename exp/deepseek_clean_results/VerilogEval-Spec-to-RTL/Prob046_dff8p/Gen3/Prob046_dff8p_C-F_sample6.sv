module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VAL = 8'h34;  // Clear definition of reset value

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;  // Reset to predefined value
    end else begin
        q <= d;          // Normal operation
    end
end

endmodule