module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter RESET_VALUE = 4'b0001;  // Reset to 1

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VALUE;        // Synchronous reset to parameterized value
    end
    else if (q[3] & q[1]) begin  // Efficient check for 10 (1010)
        q <= RESET_VALUE;        // Wrap around to reset value
    end
    else begin
        q <= q + 4'b0001;       // Normal increment
    end
end

endmodule