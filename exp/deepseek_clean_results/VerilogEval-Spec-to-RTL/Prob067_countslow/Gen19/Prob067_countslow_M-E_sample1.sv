module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset to 0
    end
    else if (slowena) begin
        // Increment when enabled, roll over at 9
        q <= (q == 4'b1001) ? 4'b0000 : q + 1'b1;
    end
    // else maintain current value (implicit)
end

endmodule