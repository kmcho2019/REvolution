module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter RESET_VALUE = 4'b0001;  // Reset to 1
localparam MAX_COUNT = 4'b1010;  // Count to 10 (1010)

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VALUE;        // Synchronous reset to 1
    end
    else if (q == MAX_COUNT) begin  // Direct comparison for 10
        q <= RESET_VALUE;        // Wrap around to 1
    end
    else begin
        q <= q + 4'b0001;       // Normal increment
    end
end

endmodule