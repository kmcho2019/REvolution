module TopModule (
    input  wire clk,  // Clock input
    input  wire d,    // Data input
    output reg  q     // Data output (registered)
);

    // Single D flip-flop capturing 'd' on the rising edge of 'clk'
    always @(posedge clk) begin
        q <= d;
    end

endmodule