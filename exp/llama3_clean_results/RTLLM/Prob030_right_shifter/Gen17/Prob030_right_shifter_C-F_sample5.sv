module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Continuous assignment to compute the next state of q
wire [7:0] next_q;
assign next_q = {d, q[7:1]};

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    q <= next_q;  // Update q with the computed next state
end

// Initialize q to 0
initial q = 8'd0;

endmodule