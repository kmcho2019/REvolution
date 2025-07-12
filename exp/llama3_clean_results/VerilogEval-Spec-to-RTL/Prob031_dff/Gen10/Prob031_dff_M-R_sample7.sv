module TopModule(
    input clk,
    input d,
    output reg q
);

// Refactored version using initial block for reset condition if needed
// and maintaining the same always_ff structure for synthesizability
always_ff @(posedge clk) begin
    q <= d; // Direct assignment for simplicity and synthesizability
end

// Optional: Adding a synchronous reset for enhanced functionality
// always_ff @(posedge clk) begin
//     if (reset) begin
//         q <= 1'b0; // Reset condition
//     end else begin
//         q <= d;
//     end
// end

endmodule