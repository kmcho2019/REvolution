module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF;  // Initialize prev_in to all ones on reset
            out <= 32'b0;             // Clear captured output on reset
        end else begin
            out <= out | (prev_in & ~in); // Capture falling edges
            prev_in <= in;                // Update prev_in for next cycle
        end
    end

endmodule