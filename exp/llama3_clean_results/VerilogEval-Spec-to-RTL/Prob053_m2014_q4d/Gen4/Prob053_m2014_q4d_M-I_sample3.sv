module TopModule(
    input clk,
    input in,
    output reg out
);

reg prev_out; // Temporary variable to hold the previous state of the flip-flop's output

always @(posedge clk) begin
    out <= in ^ prev_out; // Update the output of the flip-flop
    prev_out <= out; // Update the previous state of the flip-flop's output
end

endmodule