// Refactored TopModule implementation
module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);
    wire xor_out;

    // Define the XOR gate using assign statement
    assign xor_out = in ^ out;

    // Implement the D flip-flop using an always block
    always @(posedge clk) begin
        out <= xor_out;
    end
endmodule