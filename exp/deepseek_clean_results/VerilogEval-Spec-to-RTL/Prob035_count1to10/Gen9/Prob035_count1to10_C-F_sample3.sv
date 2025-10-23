module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters - fully configurable
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

always @(posedge clk) begin
    if (reset) begin
        q <= START;          // Synchronous reset to START value
    end
    else if (q == END) begin
        q <= START;          // Wrap around when reaching END value
    end
    else begin
        q <= q + 4'b0001;    // Normal increment
    end
end

endmodule