module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;  // Previous sensor state

    always @(posedge clk) begin
        if (reset) begin
            // Reset to maximum flow (all outputs high)
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
        end else begin
            // Store current sensor state for next cycle
            prev_s <= s;

            // Default outputs (no flow)
            {fr2, fr1, fr0} <= 3'b000;
            dfr <= 1'b0;

            // Priority encoder for water level with direct output generation
            if (s[2]) begin
                // Above s[2] - no flow
                {fr2, fr1, fr0} <= 3'b000;
            end else if (s[1]) begin
                // Between s[1] and s[2] - nominal flow fr0
                {fr2, fr1, fr0} <= 3'b001;
            end else if (s[0]) begin
                // Between s[0] and s[1] - nominal flow fr0 and fr1
                {fr2, fr1, fr0} <= 3'b011;
            end else begin
                // Below s[0] - maximum flow (all valves open)
                {fr2, fr1, fr0} <= 3'b111;
            end

            // Detect if water level is rising (any sensor newly asserted)
            dfr <= (s[0] & ~prev_s[0]) | (s[1] & ~prev_s[1]) | (s[2] & ~prev_s[2]);
        end
    end

endmodule