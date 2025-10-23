module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Detect falling edges on each bit: previous 1, current 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Capture the falling edges by setting output bits, latch until reset
            out <= out | falling_edge;
            // Update previous input for next edge detection
            prev_in <= in;
        end
    end

endmodule