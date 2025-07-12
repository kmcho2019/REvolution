module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Synchronous reset (active high) has priority
    if (r == 1'b1) begin
        q <= 1'b0;
    end
    else begin
        q <= d;
    end
end

endmodule