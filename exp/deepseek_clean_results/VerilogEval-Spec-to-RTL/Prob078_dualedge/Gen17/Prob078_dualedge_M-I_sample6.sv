module TopModule (
    input clk,
    input d,
    output q
);

    // Sequential elements with enable
    reg q_pos;  // Positive edge FF
    reg q_neg;  // Negative edge FF
    reg d_prev; // Previous input value

    // Enable generation (reduces power when input is stable)
    wire enable = (d != d_prev);

    // Positive edge triggered flip-flop with enable
    always @(posedge clk) begin
        d_prev <= d;
        if (enable) q_pos <= d;
    end

    // Negative edge triggered flip-flop with enable
    always @(negedge clk) begin
        if (enable) q_neg <= d;
    end

    // Combinational output selection
    assign q = clk ? q_pos : q_neg;

endmodule