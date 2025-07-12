module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg clk_gated;

always @(*) begin
    if (r) begin
        clk_gated = 1'b0; // Gate the clock when reset is high
    end else begin
        clk_gated = clk; // Pass the clock through when reset is low
    end
end

always @(posedge clk_gated) begin
    if (r) begin
        q <= 1'b0; // Reset the output to 0 when r is high
    end else begin
        q <= d; // Capture the input data when r is low
    end
end

endmodule