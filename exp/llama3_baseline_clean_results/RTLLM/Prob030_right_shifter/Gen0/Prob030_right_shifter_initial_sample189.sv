module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Define q as an 8-bit register

// Initialize q to 0
initial q = 8'd0;

// Perform right shift and insert new input bit on rising edge of clk
always @ (posedge clk) begin
    q = (q >> 1); // Right shift q by 1 bit
    q[7] = d;     // Insert new input bit d into the most significant position of q
end

endmodule