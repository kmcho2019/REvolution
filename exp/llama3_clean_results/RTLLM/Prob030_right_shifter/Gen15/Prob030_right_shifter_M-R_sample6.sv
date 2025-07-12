module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Compute the next state of q using a continuous assignment
wire [7:0] next_q;
assign next_q = {d, q[7:1]};

// Clocked always block to update q with the computed next state
always @(posedge clk) begin
    q <= next_q;  // Update q on every rising edge of the clock
end

// Initialize q to 0 to avoid undefined behavior
initial q = 8'd0;

endmodule