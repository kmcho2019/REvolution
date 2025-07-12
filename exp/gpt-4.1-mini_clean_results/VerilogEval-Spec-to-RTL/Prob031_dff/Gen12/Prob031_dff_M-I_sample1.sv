module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q  // corrected to output reg for flip-flop state storage
);

    // Single D flip-flop triggered on positive clock edge
    always @(posedge clk)
        q <= d;

endmodule