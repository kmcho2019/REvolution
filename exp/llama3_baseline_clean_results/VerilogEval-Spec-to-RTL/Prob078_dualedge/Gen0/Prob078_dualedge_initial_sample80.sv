module TopModule (
    input  clk,
    input  d,
    output q
);

reg clk_prev; // Previous clock state
reg q_reg;    // Registered output

always @(posedge clk or negedge clk) begin
    clk_prev <= clk; // Update previous clock state
end

always @(posedge clk) begin
    q_reg <= d; // Capture data on rising edge
end

assign q = q_reg; // Output

// Alternative implementation using single clock edge and XOR gate
// reg clk_x2; // Dual-edge clock
// always @(posedge clk) begin
//     clk_prev <= clk; // Update previous clock state
// end
// assign clk_x2 = clk ^ clk_prev; // Dual-edge clock
// always @(posedge clk_x2) begin
//     q_reg <= d; // Capture data on both edges
// end
// assign q = q_reg; // Output

endmodule