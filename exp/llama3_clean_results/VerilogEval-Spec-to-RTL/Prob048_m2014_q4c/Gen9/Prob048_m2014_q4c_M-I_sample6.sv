module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using a synchronous reset with a ternary operator for concise expression
always @(posedge clk) begin
    q <= (r == 1'b1) ? 1'b0 : d; // Explicitly compare r to 1'b1 for clarity
end

endmodule