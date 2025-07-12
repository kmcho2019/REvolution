module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs (initialized to 0 as per problem requirements)
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    
    // Sequential logic
    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;        // XOR with its own output
        and_ff <= x & ~and_ff;       // AND with complemented output
        or_ff  <= x | ~or_ff;        // OR with complemented output
    end
    
    // Output logic - 3-input NOR
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule