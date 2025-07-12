module TopModule(
    input       clk,  // Clock
    input       d,   // Data input
    input       r,   // Reset (active high)
    output reg  q    // Output
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Reset output to 0 when r is high
    end else begin
        q <= d;    // Capture 'd' when r is not high
    end
end

endmodule