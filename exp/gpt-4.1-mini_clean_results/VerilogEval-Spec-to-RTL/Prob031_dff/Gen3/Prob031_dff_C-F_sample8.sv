module TopModule (
    input  wire clk,   // Clock input
    input  wire d,     // Data input
    output reg  q      // Data output (registered flip-flop state)
);

    // Positive-edge triggered D flip-flop:
    // On each rising edge of clk, sample 'd' and store it in 'q'.
    // Note: Although the problem states 'input q', it is corrected here as output
    // because 'q' logically must be an output of the flip-flop.
    always @(posedge clk) begin
        q <= d;
    end

endmodule