module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // 8-bit register

// Initialize the register to 0
initial
begin
    q = 8'b0;
end

// Perform right shift operation on the rising edge of the clock
always @(posedge clk)
begin
    q = {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
end

endmodule