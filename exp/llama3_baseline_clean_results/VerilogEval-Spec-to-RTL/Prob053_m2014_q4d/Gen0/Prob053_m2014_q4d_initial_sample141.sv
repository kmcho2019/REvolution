module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Assign initial value to avoid latch inference
);

    wire xor_out;

    // Two-input XOR gate
    assign xor_out = in ^ out;

    // Positive edge triggered D flip-flop
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule