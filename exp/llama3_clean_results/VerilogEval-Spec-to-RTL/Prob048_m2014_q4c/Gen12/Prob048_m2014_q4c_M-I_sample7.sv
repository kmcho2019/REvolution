module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        // Explicitly reset q to 0 when r is high
        q <= 1'b0;
    end else begin
        // Otherwise, assign d to q
        q <= d;
    end
end

endmodule