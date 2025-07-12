module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Detect falling edges: bits that were 1 in previous cycle and 0 now
    assign falling_edges = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;    // Initialize prev_in to current input on reset
            out     <= 32'b0; // Clear output on reset
        end else begin
            prev_in <= in;        // Update prev_in to current input for next cycle
            out     <= out | falling_edges; // Latch detected falling edges
        end
    end

endmodule