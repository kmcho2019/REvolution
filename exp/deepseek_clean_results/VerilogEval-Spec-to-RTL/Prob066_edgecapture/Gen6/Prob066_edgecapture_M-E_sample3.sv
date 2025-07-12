module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // Two-stage pipeline for input history
    reg [31:0] in_ff1, in_ff2;

    // Edge detection logic
    wire [31:0] falling_edge;
    assign falling_edge = in_ff2 & ~in_ff1;  // 1->0 transition

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_ff1 <= 32'b0;
            in_ff2 <= 32'b0;
        end
        else begin
            // Shift input through pipeline
            in_ff2 <= in_ff1;
            in_ff1 <= in;

            // Capture falling edges (set and hold until reset)
            out <= out | falling_edge;
        end
    end

endmodule