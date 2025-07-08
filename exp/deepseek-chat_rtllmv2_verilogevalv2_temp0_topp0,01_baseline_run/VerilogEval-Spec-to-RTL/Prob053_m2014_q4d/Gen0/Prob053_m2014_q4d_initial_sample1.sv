module TopModule (
    input clk,
    input in,
    output out
);

    wire xor_out;

    // XOR gate combining input and flip-flop output
    assign xor_out = in ^ out;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule