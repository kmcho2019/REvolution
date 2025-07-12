module right_shifter #(
    parameter N = 8
)(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [N-1:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = {N{1'b0}};

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    reg [N-1:0] next_q;  // Temporary variable to compute the next state of q
    next_q[N-1] = d;  // Set the most significant bit of next_q to d
    next_q[N-2:0] = q[N-1:1];  // Right shift q by 1 bit
    q <= next_q;      // Assign the computed next state to q
end

endmodule