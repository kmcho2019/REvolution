module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Explicitly implement active-high synchronous reset
    if (r) begin
        q <= 1'b0; // Reset q to 0 when r is high
    end else begin
        q <= d; // Update q with d when r is low
    end
end

endmodule