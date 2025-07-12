module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter RESET_VAL = 4'b0001;
parameter TERMINAL_COUNT = 4'b1010;

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VAL;            // Synchronous reset to 1
    end
    else if (q == TERMINAL_COUNT) begin  // Clear comparison for terminal count
        q <= RESET_VAL;            // Wrap around to 1
    end
    else begin
        q <= q + 1'b1;            // Normal increment
    end
end

endmodule