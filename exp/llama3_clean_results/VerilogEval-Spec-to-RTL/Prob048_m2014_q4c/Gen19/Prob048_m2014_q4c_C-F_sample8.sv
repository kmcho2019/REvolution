module TopModule(
    input  logic clk,  // Clock signal
    input  logic d,    // Data input
    input  logic r,    // Reset signal (active high)
    output logic q      // Output
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d; // Directly integrate reset condition into flip-flop's update block
end

endmodule