module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters - clearly define counting range
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

always @(posedge clk) begin
    if (reset) begin
        q <= START;         // Synchronous reset to 1
    end
    else if (q == END) begin
        q <= START;         // Wrap around at 10 (direct comparison)
    end
    else begin
        q <= q + 4'b0001;  // Normal increment operation
    end
end

endmodule