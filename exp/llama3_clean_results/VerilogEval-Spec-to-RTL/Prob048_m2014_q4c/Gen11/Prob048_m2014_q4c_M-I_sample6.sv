module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using a simple and efficient synchronous reset mechanism
// with a ternary operator for concise expression and clarity
always @(posedge clk) begin
    if (r) begin
        // Synchronous reset to 0 when r is high
        q <= 1'b0;
    end else begin
        // Update q with input d when r is not high
        q <= d;
    end
end

endmodule