module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // 8-bit register to store the result of the shift operation

initial q = 8'b0;  // Initialize the register to 0

always @(posedge clk) begin
    q[7] <= d;  // Insert the new input bit into the most significant position
    for (int i = 7; i > 0; i--) begin
        q[i-1] <= q[i];  // Right shift the contents of the register by one bit
    end
end

endmodule