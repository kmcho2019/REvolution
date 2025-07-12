module TopModule (
    input clk,
    input reset,
    output reg [3:0] q = 0
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Explicitly setting q to 0 using decimal notation for clarity
    end else begin
        q <= (q == 4'd15)? 4'd0 : q + 1; // Non-blocking assignment for sequential logic consistency and handling wrap-around
    end
end

endmodule