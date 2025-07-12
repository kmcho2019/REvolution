module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter COUNT_START = 4'b0001;  // Starting value (1)
parameter COUNT_END   = 4'b1010;  // Ending value (10)

always @(posedge clk) begin
    if (reset) begin
        q <= COUNT_START;  // Synchronous reset to 1
    end
    else if (q == COUNT_END) begin
        q <= COUNT_START;  // Direct comparison for terminal count (better timing)
    end
    else begin
        q <= q + 4'b0001;  // Normal increment operation
    end
end

endmodule