module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out with a default value
);
    // Perform XOR operation directly within TopModule
    wire xor_out = in ^ out;

    // Update 'out' at positive edge of clk based on XOR result
    always @(posedge clk) begin
        out <= xor_out;
    end
endmodule