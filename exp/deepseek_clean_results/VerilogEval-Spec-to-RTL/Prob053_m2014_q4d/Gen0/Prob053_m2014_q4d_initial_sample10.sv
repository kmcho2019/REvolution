module TopModule (
    input clk,
    input in,
    output out
);

    reg out_reg;
    wire xor_out;

    // XOR gate with inputs 'in' and current output
    assign xor_out = in ^ out_reg;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        out_reg <= xor_out;
    end

    // Connect register output to module output
    assign out = out_reg;

endmodule