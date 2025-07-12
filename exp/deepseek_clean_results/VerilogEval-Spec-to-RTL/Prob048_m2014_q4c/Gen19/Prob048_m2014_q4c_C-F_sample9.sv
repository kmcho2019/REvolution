module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Synchronous reset has priority
    end else begin
        q <= d;     // Normal operation
    end
end

endmodule