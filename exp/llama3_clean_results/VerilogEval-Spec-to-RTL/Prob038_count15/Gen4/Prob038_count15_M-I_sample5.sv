module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Synchronous reset to 0
    end else if (q == 4'd15) begin
        q <= 4'd0; // Reset counter to 0 after reaching 15
    end else begin
        q <= q + 1; // Increment counter by 1 on every positive edge of the clock
    end
end

endmodule