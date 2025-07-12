module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Internal register

// Initialize the internal register to 0
initial
begin
    q = 8'b0;
end

// Always block for synchronous operation on the rising edge of the clock
always @ (posedge clk)
begin
    // Shift the contents of the q register to the right by one bit
    // and insert the new input bit d into the most significant position of the register
    q <= {d, q[7:1]};
end

endmodule