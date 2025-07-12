module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q = 1'b0  // Initialize to 0
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Synchronous reset
    end else begin
        q <= d;     // Normal operation
    end
end

endmodule