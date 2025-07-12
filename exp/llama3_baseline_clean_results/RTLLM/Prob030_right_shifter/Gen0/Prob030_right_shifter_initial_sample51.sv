module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to store the result of the right shift operation

// Initialize q to 0
initial q = 8'd0;

// Always block to handle the right shift operation
always @(posedge clk) begin
    // Right shift q by 1 bit and insert d into the most significant position
    q <= {d, q[7:1]};
end

endmodule