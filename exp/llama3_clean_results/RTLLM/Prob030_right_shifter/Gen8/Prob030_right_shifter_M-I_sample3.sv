module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

    initial q = 8'd0;  // Explicit initialization of q to 0

    always @(posedge clk) begin
        // Maintain the non-blocking assignment for reduced power consumption
        q <= {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
    end

    // No additional optimization techniques (like clock gating) are applied in this example
    // due to the simplicity of the design and the lack of specific requirements for such optimizations.

endmodule