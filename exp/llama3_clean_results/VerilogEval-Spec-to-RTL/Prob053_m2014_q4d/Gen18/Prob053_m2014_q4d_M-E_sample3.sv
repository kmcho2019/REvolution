module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

    // Combinational logic stage for XOR operation
    wire xor_result;
    assign xor_result = in ^ out;

    // Level-sensitive latch to capture XOR result
    reg latch_output;
    always @(xor_result or clk) begin
        if (clk) begin
            latch_output <= xor_result;
        end
    end

    // D flip-flop
    always @(posedge clk) begin
        out <= latch_output;
    end

endmodule