module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the 'q' register to 0
initial q = 8'b0;

// Update 'q' on each rising edge of the clock
always @(posedge clk) begin
    // Right shift 'q' by 1 bit and insert 'd' into the most significant position
    q <= {d, q[7:1]};
end

endmodule