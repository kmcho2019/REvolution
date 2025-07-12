module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @(posedge clk) begin
    reg [7:0] next_q;  // Temporary variable to hold the next state of q
    if (q == 8'bx) next_q = 8'd0;  // Initialize q to 0 if it's uninitialized
    else next_q = {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
    q <= next_q;  // Assign the next state to q
end

endmodule