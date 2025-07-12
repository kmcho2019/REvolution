module TopModule(
    input clk,
    input d,
    output reg q
);
// The existing always_ff block is optimal for sequential logic and clock edge detection.
always_ff @(posedge clk) begin
    // The direct assignment is simple and synthesizable, which is optimal for area and performance.
    q <= d;
end

endmodule