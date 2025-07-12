module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= in;          // Initialize prev_in with current input on reset to avoid spurious detections
        end else begin
            out <= out | (prev_in & ~in); // Capture falling edges from prev_in=1 to in=0
            prev_in <= in;                // Update prev_in for next cycle comparison
        end
    end

endmodule