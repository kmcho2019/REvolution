module TopModule(
    input clk,
    input in,
    output reg out
);

    reg xor_out;

    // Describe the XOR operation
    always @(*) begin
        xor_out = in ^ out;
    end

    // Describe the D flip-flop behavior on the positive edge of the clock
    always @ (posedge clk) begin
        out <= xor_out;
    end

endmodule