module DualEdgeCapture (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg d_pos, d_neg;
    reg prev_q;

    // Positive edge triggered flip-flop sampling d
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Negative edge triggered flip-flop sampling d
    always @(negedge clk) begin
        d_neg <= d;
    end

    // The XOR of the two samples indicates an edge event on data sampling
    wire sample_change = d_pos ^ d_neg;

    // Transparent latch controlled by sample_change and clk
    // When sample_change is high, latch is enabled and updates q
    // This latch is level-sensitive and only transparent when clk=1 (or 0),
    // but gating by sample_change ensures q changes only on sample differences.
    // To implement this in a synthesizable manner, use a clocked process
    // triggered by clk and sample_change asynchronously.
    always @(posedge clk or posedge sample_change) begin
        // On positive clock edge or sample change, update q to latest data
        // We use d_pos as stable input at clk high, else d_neg at clk low.
        // To be safe, update q with the latest stable sampled data:
        // However, since sample_change only toggles on data sampling,
        // update q to d_pos at clock edges.
        if (sample_change)
            q <= d_pos;
        else
            q <= q;
    end

    // Ensure q updates whenever data captured differs by updating q on sample_change pulse.
    // This design avoids latches in strict sense by using always @(posedge clk or posedge sample_change),
    // synthesizable as a clock enable triggered register in many tools.

endmodule