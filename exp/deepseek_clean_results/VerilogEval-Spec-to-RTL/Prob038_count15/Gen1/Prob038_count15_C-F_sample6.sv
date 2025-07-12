module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// 4-bit binary counter with period of 16 (0-15)
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset
    end
    else begin
        q <= (q == 4'b1111) ? 4'b0000 : q + 4'b0001;  // Count with explicit wrap
    end
end

endmodule