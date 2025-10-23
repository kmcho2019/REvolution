module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg clk_prev;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
        clk_prev <= 1'b1;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
        clk_prev <= 1'b0;
    end

    // Registered output
    always @(posedge clk, negedge clk) begin
        if (clk ^ clk_prev) begin  // Only update on actual clock edges
            q <= clk ? q_pos : q_neg;
        end
    end

endmodule