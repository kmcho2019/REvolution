module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Registered previous sensor state
    reg [2:0] prev_s;
    reg rising_edge;

    // Track sensor state changes
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            rising_edge <= 1'b0;
        end else begin
            prev_s <= s;
            // Detect if water level is rising (more sensors active than before)
            rising_edge <= (s > prev_s);
        end
    end

    // Nominal flow outputs (combinational)
    assign fr0 = ~s[2] & (s[1] | ~s[0]);  // Active in middle and low levels
    assign fr1 = ~s[2] & ~s[1] & s[0];     // Active between s[1] and s[0]
    assign fr2 = ~(|s);                    // Active only when all sensors off

    // Supplemental flow (dfr) - active when level is rising
    assign dfr = rising_edge | reset;      // Also active during reset

endmodule