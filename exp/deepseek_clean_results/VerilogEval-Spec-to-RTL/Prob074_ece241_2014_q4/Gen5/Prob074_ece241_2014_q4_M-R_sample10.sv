module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Combinational logic outputs
    wire xor_in, and_in, or_in;
    
    // XOR path: x XOR flip-flop's output
    assign xor_in = x ^ xor_ff;
    
    // AND path: x AND flip-flop's complemented output
    assign and_in = x & ~and_ff;
    
    // OR path: x OR flip-flop's complemented output
    assign or_in = x | ~or_ff;
    
    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output is NOR of all three flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (for simulation)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule