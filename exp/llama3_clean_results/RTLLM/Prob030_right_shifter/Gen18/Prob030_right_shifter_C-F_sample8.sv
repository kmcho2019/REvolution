module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'd0;

// Update q on each rising edge of the clock
always @(posedge clk) begin
    // Directly assign the shifted value to q
    q <= {d, q[7:1]};
end

endmodule