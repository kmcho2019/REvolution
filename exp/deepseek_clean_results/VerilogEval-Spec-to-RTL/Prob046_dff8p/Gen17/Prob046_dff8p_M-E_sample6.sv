module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;  // Reset to 0x34

always @(negedge clk) begin
    if (reset) begin
        // Set each bit according to the reset pattern
        q[0] <= 1'b0;  // Bit 0
        q[1] <= 1'b0;   // Bit 1
        q[2] <= 1'b1;   // Bit 2
        q[3] <= 1'b0;   // Bit 3
        q[4] <= 1'b1;   // Bit 4
        q[5] <= 1'b1;   // Bit 5
        q[6] <= 1'b0;   // Bit 6
        q[7] <= 1'b0;    // Bit 7
    end else begin
        q <= d;  // Normal operation
    end
end

endmodule