module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg d_prev;
    wire input_changed = (d != d_prev);
    
    always @(posedge clk) begin
        q_pos <= d;
        d_prev <= d;
    end
    
    always @(negedge clk) begin
        q_neg <= d;
    end
    
    always @(posedge clk or negedge clk) begin
        if (input_changed) begin
            q <= clk ? q_pos : q_neg;
        end
    end

endmodule