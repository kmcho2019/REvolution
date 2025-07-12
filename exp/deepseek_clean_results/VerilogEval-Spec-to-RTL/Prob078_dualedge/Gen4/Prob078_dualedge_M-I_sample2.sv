module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    wire clk_pos, clk_neg;

    // Clock gating logic
    assign clk_pos = clk;
    assign clk_neg = ~clk;

    // Positive edge triggered flip-flop (active only when clock is high)
    always @(posedge clk_pos) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop (active only when clock is low)
    always @(posedge clk_neg) begin
        q_neg <= d;
    end

    // Output selection and registration
    always @(posedge clk or negedge clk) begin
        q <= clk ? q_pos : q_neg;
    end

endmodule