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
    wire q_pos, q_neg;
    reg  sel; // Selection register to choose which FF output to pass

    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Register the selection signal on posedge clk:
    // sel = clk level delayed by one clock cycle (always '1' since clock is posedge)
    // Instead, toggle sel at every clk edge by toggling it on posedge to track clk phase
    // But simpler and deterministic: alternate sel each clock cycle.
    // Since clk toggles every half cycle, and outputs are stable shortly after edges,
    // toggling sel each posedge lets output select correctly q_pos or q_neg accordingly.

    // Implement sel as a toggle flip-flop synchronized to clk
    // This will select q_pos and q_neg alternately each clk cycle, mimicking dual-edge output.

    always @(posedge clk) begin
        sel <= ~sel;
    end

    // Output mux registered to clk, reduces glitches on q output
    always @(posedge clk) begin
        if (sel)
            q <= q_pos;
        else
            q <= q_neg;
    end

endmodule