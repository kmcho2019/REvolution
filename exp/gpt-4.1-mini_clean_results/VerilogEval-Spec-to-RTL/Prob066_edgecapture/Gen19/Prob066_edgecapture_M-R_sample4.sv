module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Detect falling edge: bit was 1 and now 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF; // Initialize to all ones to avoid false falling edges on first cycle
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge; // Latch falling edges permanently until reset
        end
    end

endmodule