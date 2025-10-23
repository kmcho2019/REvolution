module TopModule(clk, in, out);
    input clk;
    input in;
    output out;

    reg out_reg; // Register to hold the output of the flip-flop
    wire xor_out; // Wire for the output of the XOR gate

    // XOR gate
    assign xor_out = in ^ out_reg;

    // D Flip-Flop
    always @(posedge clk) begin
        out_reg <= xor_out;
    end

    // Continuous assignment for output
    assign out = out_reg;

endmodule