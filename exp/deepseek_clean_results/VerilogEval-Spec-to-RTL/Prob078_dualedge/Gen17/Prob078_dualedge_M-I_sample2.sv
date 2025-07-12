module TopModule (
    input clk,
    input d,
    output reg q
);

    // Dual-edge implementation with power optimization
    reg q_pos, q_neg;
    reg d_prev;
    
    always @(posedge clk) begin
        q_pos <= d;
        d_prev <= d;
    end
    
    always @(negedge clk) begin
        q_neg <= d;
    end
    
    // Registered output with change detection
    always @(posedge clk or negedge clk) begin
        if (d != d_prev) begin  // Only update when input changes
            q <= clk ? q_pos : q_neg;
        end
    end

endmodule