module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        // Synchronous reset: set q to 0 when r is high
        q <= 1'b0;
    end else if (~r) begin
        // Update q with the value of d when r is low
        q <= d;
    end
end

endmodule