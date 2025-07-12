module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Explicitly handle synchronous reset and data assignment
    if (r) begin
        // Reset q to 0 when r is high
        q <= 1'b0;
    end else begin
        // Assign d to q when r is low
        q <= d;
    end
end

endmodule