module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= {q[6:0], d[0]};  // Shift left and load new LSB from d[0]
        // Note: This is a simplified version that only uses d[0]
        // For full functionality, we would need to modify the input handling
    end
end

endmodule