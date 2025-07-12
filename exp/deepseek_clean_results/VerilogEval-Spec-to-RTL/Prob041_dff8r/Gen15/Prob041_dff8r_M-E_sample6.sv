module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q,
    input shift_enable,      // 0 = parallel load, 1 = shift mode
    input serial_in          // Data input for shift mode
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset
    end else if (shift_enable) begin
        // Shift mode: circular shift right with serial input
        q <= {serial_in, q[7:1]};
    end else begin
        // Parallel load mode
        q <= d;
    end
end

endmodule