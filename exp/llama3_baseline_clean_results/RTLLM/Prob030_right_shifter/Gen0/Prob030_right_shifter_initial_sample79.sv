module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define the q register

initial q = 8'd0;  // Initialize the q register to 0

always @(posedge clk)  // Update the q register on each rising edge of the clock
begin
    q = {d, q[7:1]};  // Right shift the q register by 1 bit and insert the new input bit d into the most significant position
end

endmodule