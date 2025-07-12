module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

    // Track previous sensor state
    reg [2:0] prev_s;

    // Current water level conditions
    wire above_s2    = (s == 3'b111);
    wire between_s2_s1 = (s == 3'b011);
    wire between_s1_s0 = (s == 3'b001);
    wire below_s0    = (s == 3'b000);

    // Previous water level conditions
    wire prev_above_s2    = (prev_s == 3'b111);
    wire prev_between_s2_s1 = (prev_s == 3'b011);
    wire prev_between_s1_s0 = (prev_s == 3'b001);
    wire prev_below_s0    = (prev_s == 3'b000);

    // Flow rate outputs (combinational)
    assign fr2 = below_s0;
    assign fr1 = below_s0 | between_s1_s0;
    assign fr0 = below_s0 | between_s1_s0 | between_s2_s1;

    // Detect if water level is rising
    wire water_rising = 
        (prev_below_s0    && (between_s1_s0 | between_s2_s1 | above_s2)) ||
        (prev_between_s1_s0 && (between_s2_s1 | above_s2)) ||
        (prev_between_s2_s1 && above_s2);

    always @(posedge clk) begin
        if (reset) begin
            // Reset state - outputs handled by combinational logic
            prev_s <= 3'b000;
            dfr <= 1'b1;  // Maximum flow on reset
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Set supplemental flow valve
            // Assert dfr if water is rising and not at maximum level
            dfr <= water_rising && !above_s2;
        end
    end

endmodule