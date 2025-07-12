module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

reg [3:0] next_q;

always @(*) begin
    // Optimized check for END value (1010)
    if (q[3] & q[1]) begin
        next_q = START;      // Wrap around to 1
    end
    else begin
        next_q = q + 4'b0001; // Increment counter
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= START;         // Synchronous reset to 1
    end
    else begin
        q <= next_q;        // Update counter
    end
end

endmodule