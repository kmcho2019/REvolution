module TopModule (
    input clk,
    input d,
    output q
);

    // Dual-edge implementation using two single-edge FFs
    reg q_pos, q_neg;
    
    always @(posedge clk) q_pos <= d;  // Positive edge capture
    always @(negedge clk) q_neg <= d;  // Negative edge capture
    
    // Glitch-free output selection
    assign q = clk ? q_pos : q_neg;    // Select most recent value

endmodule