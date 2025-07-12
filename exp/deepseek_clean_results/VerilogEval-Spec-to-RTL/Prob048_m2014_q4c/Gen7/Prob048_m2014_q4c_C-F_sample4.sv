module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    // Explicit reset condition first for clear priority
    if (r) begin
        q <= 1'b0;  // Synchronous reset
    end
    else begin
        q <= d;      // Normal operation
    end
end

endmodule