module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial begin
    q = 8'b0;  // Initialize 'q' to 0
end

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift 'q' by 1 bit and insert 'd' into the most significant position
end

endmodule