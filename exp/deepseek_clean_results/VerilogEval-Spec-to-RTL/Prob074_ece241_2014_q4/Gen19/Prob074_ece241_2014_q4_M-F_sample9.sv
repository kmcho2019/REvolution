module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs (state elements)
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    
    // Internal wires for gate outputs
    wire xor_out, and_out, or_out;

    // Gate implementations with proper feedback
    assign xor_out = x ^ xor_ff;          // XOR with its own output
    assign and_out = x & ~and_ff;         // AND with complement of its output
    assign or_out = x | ~or_ff;           // OR with complement of its output

    // Update flip-flops on clock edge
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule