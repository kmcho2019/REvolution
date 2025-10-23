module TopModule(
    input  clk,  // Clock
    input  d,   // Data input
    input  r,   // Reset (active high)
    output q    // Output
);

reg q_reg;  // Internal register to store output

always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0;  // Reset output to 0 if r is high
    end else begin
        q_reg <= d;    // Capture input data if r is low
    end
end

assign q = q_reg;  // Drive output from internal register

endmodule