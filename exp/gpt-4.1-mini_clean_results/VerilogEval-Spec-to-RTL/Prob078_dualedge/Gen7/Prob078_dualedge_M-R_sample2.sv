module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg q_pos, q_neg;

    // Positive edge triggered register
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered register
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Mux between posedge and negedge sampled values based on clock level
    assign q = clk ? q_pos : q_neg;

endmodule