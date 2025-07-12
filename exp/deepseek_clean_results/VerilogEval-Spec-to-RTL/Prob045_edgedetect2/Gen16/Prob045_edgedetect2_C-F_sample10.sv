module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle

    always @(posedge clk) begin
        // Edge detection: XOR current with previous input
        anyedge <= in ^ prev_in;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

    // Note: For power optimization, consider adding:
    // - Clock gating when inputs are stable for multiple cycles
    // - Word-level enable signals if applicable

endmodule