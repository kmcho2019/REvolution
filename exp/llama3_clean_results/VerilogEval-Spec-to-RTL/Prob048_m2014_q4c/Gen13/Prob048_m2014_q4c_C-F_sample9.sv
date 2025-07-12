module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Synchronous reset: set q to 0 when r is high
    end else begin
        q <= d; // Update q with the value of d when r is low
    end
end

endmodule