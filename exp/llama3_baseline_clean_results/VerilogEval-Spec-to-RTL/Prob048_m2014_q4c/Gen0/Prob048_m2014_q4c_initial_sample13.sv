module TopModule (
    input  clk,  // Clock signal
    input  d,    // Input data
    input  r,    // Active high reset
    output q     // Output
);

reg q_reg;  // Internal register for output
assign q = q_reg;  // Continuous assignment to output

always @(posedge clk) begin
    if (r) begin  // Check for active high reset
        q_reg <= 1'b0;  // Reset output to 0
    end else begin
        q_reg <= d;  // Update output with input value
    end
end

endmodule