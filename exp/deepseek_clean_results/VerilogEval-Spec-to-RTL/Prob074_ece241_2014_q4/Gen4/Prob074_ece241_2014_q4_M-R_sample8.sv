module TopModule (
    input clk,
    input x,
    output z
);

    // Three separate flip-flops
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff  = 1'b0;
    
    // Gate logic with proper feedback
    wire xor_gate = x ^ xor_ff;
    wire and_gate = x & ~and_ff;
    wire or_gate  = x | ~or_ff;
    
    // Update flip-flops on clock edge
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff  <= or_gate;
    end
    
    // Output is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule