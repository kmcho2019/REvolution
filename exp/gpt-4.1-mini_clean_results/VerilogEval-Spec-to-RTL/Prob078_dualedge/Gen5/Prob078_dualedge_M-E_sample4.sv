module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_div;       // Toggles at every clock edge (emulating half frequency)
    reg d_sampled;     // Data sampled at edges

    // Generate clk_div toggling at every edge by toggling on posedge clk
    // and using the delayed clk to detect edges
    always @(posedge clk) begin
        clk_div <= ~clk_div;
    end

    // On posedge clk, if clk_div toggled, sample data
    // Since clk_div toggles every posedge clk, it effectively samples data on each edge (rising and falling)
    always @(posedge clk) begin
        d_sampled <= d;
        q <= d_sampled;
    end

endmodule