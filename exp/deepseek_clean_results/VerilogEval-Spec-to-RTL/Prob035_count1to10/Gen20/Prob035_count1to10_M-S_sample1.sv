module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0001;          // Reset to 1
    else if (q[3] & q[1])      // Detect 10 (1010)
        q <= 4'b0001;
    else
        q <= q + 4'b0001;     // Increment
end

endmodule