module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Reset output to 0 on rising edge of clk when r is high
    end else begin
        q <= d; // Capture data on rising edge of clk when r is low
    end
end

endmodule