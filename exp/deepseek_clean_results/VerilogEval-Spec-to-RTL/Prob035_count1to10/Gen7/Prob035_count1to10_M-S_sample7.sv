module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1
    end
    else begin
        if (q == 4'b1010)  // If current count is 10
            q <= 4'b0001;  // Wrap around to 1
        else
            q <= q + 1;    // Otherwise increment
    end
end

endmodule