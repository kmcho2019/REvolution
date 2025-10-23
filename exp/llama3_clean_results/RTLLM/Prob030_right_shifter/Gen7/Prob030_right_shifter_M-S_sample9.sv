module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @(posedge clk) begin
    q <= (q == 8'bx)? 8'd0 : {d, q[7:1]};  // Initialize 'q' to 0 if it's uninitialized and then right shift 'q' by 1 bit and insert 'd' into the most significant position
end

endmodule