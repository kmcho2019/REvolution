module TopModule (
    input clk,
    input in,
    output out
);

    wire xor_out;

    // XOR gate: input 'in' and feedback from flip-flop output 'out'
    assign xor_out = in ^ out;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule