module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg clk_gated;  // Gated clock signal
reg d_prev;     // Previous value of 'd'

always @(*) begin
    // Clock gating: only update 'q' when 'd' changes
    clk_gated = (d !== d_prev) ? 1'b1 : 1'b0;
end

always @(posedge clk) begin
    d_prev <= d;  // Update previous value of 'd'
    
    if (clk_gated) begin
        // Right shift 'q' by 1 bit and insert 'd' into the most significant position
        q <= {d, q[7:1]};
    end
end

endmodule