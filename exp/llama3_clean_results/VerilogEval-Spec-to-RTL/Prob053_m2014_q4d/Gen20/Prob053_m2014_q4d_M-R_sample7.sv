module TopModule(
    input clk,
    input in,
    output reg out
);

    // Wire for XOR operation
    wire xor_result;
    assign xor_result = in ^ out;

    // D flip-flop operation
    always @(posedge clk) begin
        // Capture result of XOR operation on positive edge of clock
        out <= xor_result;
    end

endmodule