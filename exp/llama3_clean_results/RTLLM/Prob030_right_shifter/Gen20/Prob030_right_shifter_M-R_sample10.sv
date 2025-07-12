module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0 to ensure a known starting state
initial q = 8'd0;

// Sequential logic block to update q on each rising edge of the clock
always @(posedge clk) begin
    // Directly assign the shifted value to q, minimizing logic and switching activity
    q <= {d, q[7:1]};
end

endmodule