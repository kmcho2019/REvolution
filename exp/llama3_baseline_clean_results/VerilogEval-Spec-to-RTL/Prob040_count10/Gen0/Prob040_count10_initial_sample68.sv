module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Synchronous reset to 0
    end else if (q == 4'd9) begin
        q <= 4'd0; // Reset counter to 0 when it reaches 9
    end else begin
        q <= q + 1; // Increment counter
    end
end

endmodule