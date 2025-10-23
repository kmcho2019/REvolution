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
        if (q == 4'b1010)  // Explicit comparison for 10
            q <= 4'b0001;  // Wrap to 1
        else
            q <= q + 1;   // Normal increment
    end
end

endmodule