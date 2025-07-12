// Refactored Verilog code for a D flip-flop
module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q // Output of the D flip-flop
);

// Initialize q to a default value for a defined startup state
initial q = 1'b0;

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment to ensure proper sequential logic behavior
    q <= d;
end

// Optional: Including an asynchronous reset for completeness
// always @(posedge clk or posedge rst) begin
//     if (rst) begin
//         q <= 1'b0; // Reset value
//     end else begin
//         q <= d;
//     end
// end

endmodule