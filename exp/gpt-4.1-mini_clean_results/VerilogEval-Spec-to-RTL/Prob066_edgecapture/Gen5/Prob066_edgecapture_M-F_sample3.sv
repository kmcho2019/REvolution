module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Register to hold previous input value; reset to zero for a known state
    always @(posedge clk) begin
        if (reset)
            prev_in <= 32'b0;
        else
            prev_in <= in;
    end

    // Compute falling edges as a continuous assignment outside procedural blocks
    assign falling_edges = prev_in & ~in;

    // Capture falling edges (1->0) and latch them in 'out' until reset
    always @(posedge clk) begin
        if (reset)
            out <= 32'b0;
        else if (|falling_edges)
            out <= out | falling_edges;
    end

endmodule