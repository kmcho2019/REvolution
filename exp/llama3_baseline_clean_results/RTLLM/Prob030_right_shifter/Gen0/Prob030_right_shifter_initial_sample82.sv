module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the q register to 0
initial q = 8'd0;

// Perform right shift operation on the rising edge of the clock
always @(posedge clk) begin
    // Right shift the q register by 1 bit and assign the input 'd' to the most significant bit
    q = {d, q[7:1]};
end

endmodule