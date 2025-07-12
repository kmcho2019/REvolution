module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        // Synchronous reset
        q <= 1'b0;
    end else begin
        // Data assignment
        q <= d;
    end
end

endmodule