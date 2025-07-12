module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Feedback wires from flip-flop outputs
    wire xor_fb = xor_ff;
    wire and_fb = and_ff;
    wire or_fb = or_ff;
    
    // Gate inputs (combinational logic)
    wire xor_in = x ^ xor_fb;
    wire and_in = x & ~and_fb;
    wire or_in = x | ~or_fb;
    
    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (for simulation only)
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff = 0;
    end

endmodule