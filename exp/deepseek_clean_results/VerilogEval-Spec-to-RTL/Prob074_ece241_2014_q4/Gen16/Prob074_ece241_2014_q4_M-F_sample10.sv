module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs with reset
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    
    // Combinational logic for gate outputs
    wire xor_in = x ^ xor_ff;
    wire and_in = x & ~and_ff;
    wire or_in = x | ~or_ff;
    
    // Sequential logic (flip-flop updates)
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule