module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Explicitly reset the counter to 0
        q <= 4'd0;
    end else begin
        // Clearly define the increment operation
        q <= (q == 4'd15) ? 4'd0 : (q + 1'd1);
    end
end

endmodule