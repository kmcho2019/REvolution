module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial q = 8'd0;  // Initialize q to 0

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Directly update q without a temporary variable
end

endmodule