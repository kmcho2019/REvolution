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

    // Register previous input, initialized to current input on reset to avoid false edges
    always @(posedge clk) begin
        if (reset)
            prev_in <= in;  // Initialize prev_in to input on reset
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