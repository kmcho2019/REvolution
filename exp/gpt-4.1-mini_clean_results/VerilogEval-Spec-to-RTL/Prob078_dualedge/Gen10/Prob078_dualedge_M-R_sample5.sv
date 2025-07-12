module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    wire clk_n = ~clk;
    reg q_pos, q_neg;

    // Positive edge FF
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge FF (captured on rising edge of inverted clk)
    always @(posedge clk_n) begin
        q_neg <= d;
    end

    // Mux output based on clock level
    assign q = clk ? q_pos : q_neg;

endmodule