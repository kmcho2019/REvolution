module TopModule (
    input clk,
    input d,
    output reg q
);

    // Dual-edge implementation with power optimization
    reg q_pos, q_neg;
    
    // Positive edge triggered FF with implicit clock gating
    always @(posedge clk) begin
        q_pos <= d;
        q <= d;  // Update output immediately on posedge
    end
    
    // Negative edge triggered FF with implicit clock gating
    always @(negedge clk) begin
        q_neg <= d;
        q <= q_neg;  // Update output immediately on negedge
    end

endmodule