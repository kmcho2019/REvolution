module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Reset output to 0 when r is high
    end else begin
        q <= d; // Update output with d when r is low
    end
end

// Alternatively, for educational purposes, here's how you might conceptually visualize the MUX approach,
// though in practice, the above implementation is more straightforward and efficient for a D flip-flop.
// always @(posedge clk) begin
//     q <= (r) ? 1'b0 : d;
// end

endmodule