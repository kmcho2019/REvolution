module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
    );

reg [7:0] q; // 8-bit register

initial
    q = 8'd0; // Initialize the register to 0

always @ (posedge clk)
begin
    // Shift the current value of q to the right by one bit
    // and insert the new input bit into the most significant position
    q <= {d, q[7:1]};
end

endmodule