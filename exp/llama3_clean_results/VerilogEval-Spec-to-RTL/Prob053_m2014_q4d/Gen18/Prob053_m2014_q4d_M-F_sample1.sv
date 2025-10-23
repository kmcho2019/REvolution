module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out with a default value
);
    // Intermediate signal to store XOR result
    reg xor_out;

    // Combinational logic to perform XOR operation
    always @(*) begin
        xor_out = in ^ out;
    end

    // Sequential logic to update 'out' at positive edge of clk
    always @(posedge clk) begin
        out <= xor_out;
    end
endmodule