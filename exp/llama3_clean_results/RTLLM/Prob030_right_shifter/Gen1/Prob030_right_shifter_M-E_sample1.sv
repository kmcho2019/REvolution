module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] internal_q;  // Internal 8-bit register

initial internal_q = 8'd0;  // Initialize internal_q to 0

always @(posedge clk) begin
    internal_q <= {d, internal_q[7:1]};  // Right shift internal_q by 1 bit and insert d into the most significant position
end

assign q = internal_q;  // Assign the value of internal_q to output q

endmodule