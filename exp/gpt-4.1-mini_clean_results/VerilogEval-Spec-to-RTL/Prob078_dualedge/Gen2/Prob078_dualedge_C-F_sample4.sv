module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos;
    reg q_neg;
    reg toggle;       // Toggles every clock edge to enable q update

    // Capture input on positive edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture input on negative edge and toggle the enable signal
    always @(negedge clk) begin
        q_neg <= d;
        toggle <= ~toggle;
    end

    wire mux_out;
    // Mux between q_pos and q_neg based on clock level
    assign mux_out = clk ? q_pos : q_neg;

    // Register the mux output on posedge clock, enabled every half cycle
    // This registers the dual-edge sampled data to prevent glitches
    always @(posedge clk) begin
        if (toggle)
            q <= mux_out;
    end

endmodule