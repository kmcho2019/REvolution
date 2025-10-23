module TopModule (
    input clk,
    input in,
    output out
);

    reg out_reg;
    wire d_input;

    // XOR of input and current output (feedback)
    assign d_input = in ^ out_reg;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        out_reg <= d_input;
    end

    assign out = out_reg;

endmodule