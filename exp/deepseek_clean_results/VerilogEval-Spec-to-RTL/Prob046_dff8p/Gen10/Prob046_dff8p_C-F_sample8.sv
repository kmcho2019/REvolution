module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Reset value 0x34 = 8'b00110100
// Bit positions: 7 6 5 4 3 2 1 0
// Reset values:  0 0 1 1 0 1 0 0
localparam RESET_VAL = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;  // Synchronous reset to 0x34
    end else begin
        q <= d;          // Normal operation
    end
end

endmodule