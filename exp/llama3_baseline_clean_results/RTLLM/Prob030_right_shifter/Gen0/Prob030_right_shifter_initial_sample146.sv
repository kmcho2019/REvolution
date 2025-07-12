module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // 8-bit register

// Initialize the register q to 0
initial
begin
    q = 8'b0;
end

// Perform right shift operation on the positive edge of the clock signal
always @(posedge clk)
begin
    // Shift the contents of q to the right by one bit and insert d into the most significant position
    q = {d, q[7:1]};
end

endmodule