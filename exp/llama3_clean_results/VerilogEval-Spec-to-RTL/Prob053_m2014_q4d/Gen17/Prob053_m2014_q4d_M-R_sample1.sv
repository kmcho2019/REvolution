// Refactored TopModule implementation
module TopModule(
    input clk,
    input in,
    output reg out
);
    initial out = 1'b0; // Explicitly initialize out for clarity

    always @(posedge clk) begin
        reg temp_out; // Temporary variable to hold the result of XOR
        temp_out = in ^ out; // Perform XOR operation
        out <= temp_out; // Update out using non-blocking assignment
    end
endmodule