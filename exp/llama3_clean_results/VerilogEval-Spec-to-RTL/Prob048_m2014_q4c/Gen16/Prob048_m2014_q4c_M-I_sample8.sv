module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// The always block is triggered at the positive edge of the clock signal (clk).
always @(posedge clk) begin
    // If the reset signal (r) is high, reset the output (q) to 0.
    if (r) begin
        // Synchronous reset to 0 when r is high.
        q <= 1'b0;
    end else begin
        // Otherwise, on the next clock edge, assign the input (d) to the output (q).
        q <= d;
    end
end

endmodule