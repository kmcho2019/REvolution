module TopModule (
    input clk,
    input in,
    output out
);

    wire xor_out;

    // XOR gate with inputs 'in' and current flip-flop output
    assign xor_out = in ^ out;

    // Positive edge-triggered D flip-flop with no reset
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule