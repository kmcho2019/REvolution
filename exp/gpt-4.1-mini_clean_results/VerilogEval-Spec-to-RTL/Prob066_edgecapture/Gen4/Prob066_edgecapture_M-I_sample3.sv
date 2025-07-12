module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    // Register to hold previous input value; reset to zero for a known state
    always @(posedge clk) begin
        if (reset)
            prev_in <= 32'b0;
        else
            prev_in <= in;
    end

    // Capture falling edges (1->0) and latch them in 'out' until reset
    always @(posedge clk) begin
        if (reset)
            out <= 32'b0;
        else begin
            // Compute falling edges
            wire [31:0] falling_edges = prev_in & ~in;
            // Update 'out' only if new falling edges are detected to reduce toggling
            if (|falling_edges)
                out <= out | falling_edges;
        end
    end

endmodule