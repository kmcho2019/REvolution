module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'd0;

// Internal signal to connect the barrel shifter and the multiplexer
reg [7:0] shifted_q;

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    // Barrel shifter: shift q to the right by one bit
    shifted_q <= q >> 1;
    
    // Multiplexer: insert d into the most significant position of the register
    q <= {d, shifted_q[7:1]};
end

endmodule