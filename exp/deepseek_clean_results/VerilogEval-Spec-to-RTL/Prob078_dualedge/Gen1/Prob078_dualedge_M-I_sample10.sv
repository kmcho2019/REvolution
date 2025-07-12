module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    wire q_pre;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Intermediate mux
    assign q_pre = clk ? q_pos : q_neg;

    // Output register (dual-edge triggered)
    always @(posedge clk or negedge clk) begin
        q <= q_pre;
    end

endmodule