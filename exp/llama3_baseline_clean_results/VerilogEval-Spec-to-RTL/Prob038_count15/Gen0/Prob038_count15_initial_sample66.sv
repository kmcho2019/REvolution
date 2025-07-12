module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset, set count to 0
        q <= 4'd0;
    end else begin
        // Increment count
        q <= q + 1;
    end
end

endmodule