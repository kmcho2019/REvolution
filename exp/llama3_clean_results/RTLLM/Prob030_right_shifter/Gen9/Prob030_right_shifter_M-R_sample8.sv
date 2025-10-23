module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] next_q;  // Next state of q

// Combinational logic to compute the next state of q
assign next_q = {d, q[7:1]};

// Flip-flop to store the next state of q
always @(posedge clk) begin
    q <= next_q;
end

initial q = 8'd0;  // Initialize q to 0

endmodule