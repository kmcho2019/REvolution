module DFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    wire clk_n = ~clk;
    wire q_pos, q_neg;

    DFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    DFF u_neg_ff (
        .clk(clk_n),
        .d(d),
        .q(q_neg)
    );

    // Simple ternary mux to select q based on clk level
    assign q = clk ? q_pos : q_neg;

endmodule