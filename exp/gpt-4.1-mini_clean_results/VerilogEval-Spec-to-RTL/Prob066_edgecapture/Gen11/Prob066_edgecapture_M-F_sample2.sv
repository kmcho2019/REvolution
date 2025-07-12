module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational detection of falling edges (1->0)
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;       // Initialize prev_in to current input to prevent false detection
            out <= 32'b0;        // Clear captured output on reset
        end else begin
            prev_in <= in;             // Update prev_in for next cycle
            out <= out | falling_edge; // Capture and hold falling edges
        end
    end

endmodule