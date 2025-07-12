module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @(posedge clk) begin
    if (q == 8'bx) q <= 8'd0;  // Initialize q to 0 if it's uninitialized
    q <= {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
end

endmodule