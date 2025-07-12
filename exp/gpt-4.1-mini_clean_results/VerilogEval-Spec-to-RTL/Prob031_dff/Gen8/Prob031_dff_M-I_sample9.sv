module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q  // Corrected q to output reg to store flip-flop state
);

    // Single D flip-flop inferred directly
    always @(posedge clk)
        q <= d;

endmodule