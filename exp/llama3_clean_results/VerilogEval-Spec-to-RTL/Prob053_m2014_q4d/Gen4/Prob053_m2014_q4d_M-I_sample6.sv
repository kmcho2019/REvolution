module TopModule(
    input clk,
    input in,
    output reg out
);

reg prev_out; // Temporary variable to hold the previous state of 'out'

always @(*) begin
    prev_out = out; // Update prev_out with the current state of 'out'
end

always @(posedge clk) begin
    out <= in ^ prev_out; // Use prev_out in the XOR operation
end

endmodule