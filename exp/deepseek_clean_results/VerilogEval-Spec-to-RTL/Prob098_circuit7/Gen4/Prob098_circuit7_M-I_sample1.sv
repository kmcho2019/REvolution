module TopModule (
    input clk,    // Clock input
    input a,      // Data input
    output reg q   // Registered output
);

// Synchronous logic with implicit reset to 0 (Xilinx style)
always @(posedge clk) begin
    q <= ~a;      // Output is inverted input sampled at clock edge
end

endmodule