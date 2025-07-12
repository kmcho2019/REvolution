module TopModule(
    input wire clk,    // Clock input
    input wire d,      // Data input
    output reg q       // Output register
    // Note: Adding reset would require changing interface:
    // input wire rst_n  // Active-low reset (optional)
);

    // Positive-edge triggered D flip-flop
    always @(posedge clk) begin
        q <= d;  // Non-blocking assignment for proper sequential logic
    end

    /* Uncomment if reset is needed:
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 1'b0;
        else        q <= d;
    end
    */
endmodule