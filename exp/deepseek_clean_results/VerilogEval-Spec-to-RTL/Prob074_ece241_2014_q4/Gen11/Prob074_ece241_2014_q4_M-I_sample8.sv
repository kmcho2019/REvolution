module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;

    // XOR path: x XOR previous xor_ff output
    wire xor_next = x ^ xor_ff;
    
    // AND path: x AND complement of previous and_ff output
    wire and_next = x & ~and_ff;
    
    // OR path: x OR complement of previous or_ff output
    wire or_next = x | ~or_ff;

    // Update all flip-flops on positive clock edge
    always @(posedge clk) begin
        xor_ff <= xor_next;
        and_ff <= and_next;
        or_ff  <= or_next;
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule