module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Combinational detection of falling edges
    assign falling_edges = prev_in & ~in;

    // Register previous input
    always @(posedge clk) begin
        if (reset)
            prev_in <= 32'hFFFFFFFF;  // Initialize to all ones to avoid false edge detection
        else
            prev_in <= in;
    end

    // Register output with latch-once logic for falling edges
    always @(posedge clk) begin
        if (reset)
            out <= 32'b0;
        else
            out <= out | falling_edges;
    end

endmodule