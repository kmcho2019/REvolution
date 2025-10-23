module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

always @(posedge clk) begin
    if (reset) begin
        q <= START;  // Synchronous reset to 1
    end
    else if (q[3] & q[1]) begin
        q <= START;  // Optimized check for 10 (1010) - bits 3 and 1 are 1
    end
    else begin
        q <= q + 4'b0001;  // Normal increment
    end
end

endmodule