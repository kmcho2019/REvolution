module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Combinational logic for each path
    wire xor_in = x ^ xor_ff;
    wire and_in = x & ~and_ff;
    wire or_in = x | ~and_ff;  // Note: Using ~and_ff as specified
    
    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff  <= or_in;
    end
    
    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule