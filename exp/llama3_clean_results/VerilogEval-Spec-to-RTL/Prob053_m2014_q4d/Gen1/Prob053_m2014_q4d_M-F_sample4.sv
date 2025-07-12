module TopModule(
    input clk,
    input in,
    output reg out
);

reg temp_out; // Temporary variable to hold the result of the XOR operation

always @(posedge clk) begin
    temp_out = in ^ out; // Blocking assignment to update the temporary variable
    out <= temp_out; // Non-blocking assignment to update the out signal
end

endmodule