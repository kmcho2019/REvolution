module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_ff1, in_ff2;
    wire [31:0] falling_edge;

    // Two-stage input pipeline for stable edge detection
    always @(posedge clk) begin
        if (reset) begin
            in_ff1 <= 32'b0;
            in_ff2 <= 32'b0;
        end else begin
            in_ff1 <= in;
            in_ff2 <= in_ff1;
        end
    end

    // Falling edge detection (compares two clock cycles ago with one clock cycle ago)
    assign falling_edge = in_ff2 & ~in_ff1;

    // Capture register with explicit latching behavior
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            // For each bit: if we see a falling edge or if it was already set
            out <= out | falling_edge;
        end
    end

endmodule