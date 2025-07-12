module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to store the right-shifted value

initial begin  // Initialize the register 'q' to 0
    q = 8'd0;
end

always @ (posedge clk) begin  // Perform the right shift operation on each rising edge of the clock
    q <= {d, q[7:1]};  // Right-shift 'q' by 1 bit and insert 'd' into the most significant position
end

endmodule