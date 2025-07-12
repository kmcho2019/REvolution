module PosEdgeFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input clk,
    input d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output q
);

    wire q_posedge, q_negedge;

    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Continuous mux selects data sampled on latest clock edge
    assign q = clk ? q_posedge : q_negedge;

endmodule