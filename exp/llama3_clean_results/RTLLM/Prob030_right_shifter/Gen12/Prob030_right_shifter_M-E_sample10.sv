module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'd0;

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    // Use concatenation to insert d at the most significant position and shift existing bits to the right
    q <= {d, q[7:1]};
end

endmodule