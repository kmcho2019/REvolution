module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to store the current state of the right shift operation

initial q = 8'b0;  // Initialize the register to 0

always @(posedge clk) begin
    // Shift the contents of the q register to the right by one bit
    q <= {d, q[7:1]}; 
end

endmodule