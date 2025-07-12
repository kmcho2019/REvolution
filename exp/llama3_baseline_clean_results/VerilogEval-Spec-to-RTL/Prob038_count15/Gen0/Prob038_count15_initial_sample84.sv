module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to 0
        q <= 4'd0;
    end else begin
        // Increment the counter
        q <= q + 1'd1;
    end
end

endmodule