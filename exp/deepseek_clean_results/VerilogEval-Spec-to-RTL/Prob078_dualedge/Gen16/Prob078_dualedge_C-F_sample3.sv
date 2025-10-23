module TopModule (
    input clk,
    input d,
    output q
);

    // Dual-edge implementation using two single-edge FFs
    reg q_pos, q_neg;
    
    // Positive edge triggered FF
    always @(posedge clk) q_pos <= d;
    
    // Negative edge triggered FF
    always @(negedge clk) q_neg <= d;
    
    // Output selection - selects most recent value
    assign q = clk ? q_pos : q_neg;

endmodule