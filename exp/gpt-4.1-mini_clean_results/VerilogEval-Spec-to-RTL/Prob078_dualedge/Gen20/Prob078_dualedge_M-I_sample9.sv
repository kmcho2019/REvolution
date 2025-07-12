module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Negative edge-triggered flip-flop
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    wire q_pos, q_neg;

    // Instantiate flip-flops clocked on opposite edges
    PosEdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    NegEdgeFF u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Level-sensitive latch controlled by clk:
    // When clk=1, latch follows q_pos; when clk=0, latch follows q_neg.
    // This reduces mux glitches and power consumption.
    always @(clk or q_pos or q_neg) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule