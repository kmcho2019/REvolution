module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Define 8 flip-flops to represent the output register q
reg [7:0] q_ff;

// Initialize q to 0
initial q = 8'd0;
initial q_ff = 8'd0;

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    // Load the input signal d into the most significant bit flip-flop
    q_ff[7] <= d;
    
    // Shift the values of the existing flip-flops to the right
    for (int i = 6; i >= 0; i--) begin
        q_ff[i] <= q_ff[i+1];
    end
    
    // Update the output register q
    q <= q_ff;
end

endmodule