module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Mask with '1's at tap positions (31,21,1,0)
localparam [31:0] TAP_MASK = 32'h80000203;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Shift right and XOR taps with LSB
        q <= {1'b0, q[31:1]} ^ (TAP_MASK & {32{q[0]}});
    end
end

endmodule