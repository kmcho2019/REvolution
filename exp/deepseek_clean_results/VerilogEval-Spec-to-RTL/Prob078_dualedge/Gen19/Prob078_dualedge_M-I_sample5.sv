module TopModule (
    input clk,
    input d,
    output q
);

    // Sequential elements with clock gating
    reg q_pos, q_neg;
    reg d_prev;
    
    // Stability detection
    wire stable = (d == d_prev);
    
    // Positive edge triggered with conditional clock
    always @(posedge clk) begin
        d_prev <= d;
        if (!stable) q_pos <= d;
    end

    // Negative edge triggered with conditional clock
    always @(negedge clk) begin
        if (!stable) q_neg <= d;
    end

    // Optimized output selection using XOR (saves LUT)
    assign q = q_pos ^ q_neg ^ clk;

endmodule