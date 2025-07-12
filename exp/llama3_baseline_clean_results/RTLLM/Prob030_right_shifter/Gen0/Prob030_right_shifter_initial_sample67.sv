module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to store the current state of the shift operation

initial q = 8'd0;  // Initialize the register to 0

always @ (posedge clk) begin
    q <= {d, q[7:1]};  // Right-shift the contents of q by one bit and insert the new input bit d
end

endmodule