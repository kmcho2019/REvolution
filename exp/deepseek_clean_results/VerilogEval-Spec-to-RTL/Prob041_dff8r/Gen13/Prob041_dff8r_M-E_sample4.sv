module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Internal flip-flop chain
    reg [7:0] ff_chain;

    always @(posedge clk) begin
        if (reset) begin
            ff_chain <= 8'b0;  // Synchronous reset clears all FFs
        end else begin
            // Circular buffer implementation
            ff_chain <= {ff_chain[6:0], d[7]};  // Shift left with new bit
            ff_chain[7] <= d[7];  // Maintain the MSB separately
        end
    end

    // Tap outputs from each flip-flop
    assign q = ff_chain;

endmodule