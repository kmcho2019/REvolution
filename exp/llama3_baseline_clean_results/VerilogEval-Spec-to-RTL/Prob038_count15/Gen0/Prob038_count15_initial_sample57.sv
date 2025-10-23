module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset, set q to 0 when reset is high
        q <= 4'd0;
    end else if (q == 4'd15) begin
        // Wrap around to 0 after reaching the maximum count
        q <= 4'd0;
    end else begin
        // Increment q by 1 for each clock cycle when reset is low
        q <= q + 1'b1;
    end
end

endmodule