module PosEdgeFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire d,
    output reg q
);
    wire q_posedge, q_negedge;

    PosEdgeFF u_posedge_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    NegEdgeFF u_negedge_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    always @(*) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end
endmodule