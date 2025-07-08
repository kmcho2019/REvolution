module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding for water level
    localparam BELOW       = 2'd0; // no sensors asserted
    localparam BETWEEN_1_0 = 2'd1; // s[0] only
    localparam BETWEEN_2_1 = 2'd2; // s[0] and s[1]
    localparam ABOVE       = 2'd3; // s[0], s[1], s[2]

    reg [1:0] current_level, prev_level;

    // Determine current water level based on sensor inputs
    always @(*) begin
        case (s)
            3'b111: current_level = ABOVE;
            3'b011: current_level = BETWEEN_2_1;
            3'b001: current_level = BETWEEN_1_0;
            3'b000: current_level = BELOW;
            default: begin
                // Handle intermediate or invalid sensor states:
                // We prioritize the highest asserted sensor to determine level
                // For example: 3'b010 (only s[1]) or 3'b100 (only s[2])
                // Map them to closest category
                if (s[2]) current_level = ABOVE;          // treat any s[2] asserted as ABOVE
                else if (s[1]) current_level = BETWEEN_2_1; // s[1] asserted only
                else if (s[0]) current_level = BETWEEN_1_0;
                else current_level = BELOW;
            end
        endcase
    end

    // Sequential logic to store previous level and generate outputs
    always @(posedge clk) begin
        if (reset) begin
            // Reset to state equivalent to water level low for a long time:
            // BELOW, all flow valves open
            prev_level <= BELOW;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update previous level
            prev_level <= current_level;

            // Nominal flow rate signals based on current_level
            case (current_level)
                ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_2_1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_1_0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // default to safe (max flow)
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Determine if supplemental flow valve dfr should be on
            // dfr = 1 if previous level < current level (water rising)
            if (prev_level < current_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule