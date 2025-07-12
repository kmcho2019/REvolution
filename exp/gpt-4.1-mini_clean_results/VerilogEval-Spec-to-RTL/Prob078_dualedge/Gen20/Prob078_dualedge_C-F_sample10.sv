module PosEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    wire q_pos;
    wire q_neg;

    // Two flip-flops sampling 'd' on posedge and negedge clk
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

    // Registered mux output to avoid glitches and reduce dynamic power:
    // On each posedge clk, sample clk level (which is always 1) and select between q_pos and q_neg.
    // Because clk=1 at posedge, this mux select simplifies to always q_pos or stable selection,
    // but to keep formalism, select based on stored clk_level.
    reg clk_level_d;

    // Sample clk level at posedge to use as mux select next cycle
    always @(posedge clk) begin
        clk_level_d <= clk;
        // Select output from q_pos or q_neg based on sampled clk level
        // Since clk is 1 at posedge, this stores q_pos by default,
        // but holding previous clk level helps handle stable output between edges.
        if (clk_level_d)
            q <= q_pos;
        else
            q <= q_neg;
    end

endmodule