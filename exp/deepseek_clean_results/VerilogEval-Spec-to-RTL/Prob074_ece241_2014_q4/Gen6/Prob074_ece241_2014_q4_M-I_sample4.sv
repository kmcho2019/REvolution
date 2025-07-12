module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flops for each path
    reg xor_ff, and_ff, or_ff;
    
    // Feedback signals with explicit inversion where needed
    wire xor_in = x ^ xor_ff;
    wire and_in = x & ~and_ff;
    wire or_in = x | ~or_ff;
    
    // Sequential logic with explicit reset to 0
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output logic - 3-input NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule