module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;      // Initialize prev_in to current input to avoid false edge detection after reset
            out <= 32'b0;       // Clear captured output on reset
        end else begin
            prev_in <= in;
            out <= out | falling_edge; // Capture falling edges persistently
        end
    end

endmodule