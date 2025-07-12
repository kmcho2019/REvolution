module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    reg [7:0] next_q;  // Temporary variable to compute the next state of q
    next_q = q >> 1;  // Right shift q by 1 bit
    next_q[7] = d;    // Set the most significant bit of next_q to d
    q <= next_q;      // Assign the computed next state to q
end

// Initialize q to 0
initial q = 8'd0;

endmodule