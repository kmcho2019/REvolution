module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    wire xor_q, and_q, or_q;
    
    // XOR path: x XOR q (direct feedback)
    wire xor_d;
    assign xor_d = x ^ xor_q;
    dff xor_ff (
        .clk(clk),
        .d(xor_d),
        .q(xor_q)
    );
    
    // AND path: x AND ~q (complemented feedback)
    wire and_d;
    assign and_d = x & ~and_q;
    dff and_ff (
        .clk(clk),
        .d(and_d),
        .q(and_q)
    );
    
    // OR path: x OR ~q (complemented feedback)
    wire or_d;
    assign or_d = x | ~or_q;
    dff or_ff (
        .clk(clk),
        .d(or_d),
        .q(or_q)
    );
    
    // Final NOR gate
    assign z = ~(xor_q | and_q | or_q);

endmodule

// Basic D flip-flop with synchronous reset to 0
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule