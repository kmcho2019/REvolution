module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs with initial values
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff  = 1'b0;
    
    // Combinational logic
    wire xor_out = x ^ xor_ff;        // XOR with flip-flop output
    wire and_out = x & ~and_ff;       // AND with complemented flip-flop output
    wire or_out  = x | or_ff;         // OR with flip-flop output (complement is already specified)
    
    // Sequential logic
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff  <= or_out;
    end
    
    // Final NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule