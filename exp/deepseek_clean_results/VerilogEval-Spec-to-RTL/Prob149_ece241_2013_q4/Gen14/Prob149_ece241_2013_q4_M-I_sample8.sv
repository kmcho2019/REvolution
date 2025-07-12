module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Current and previous water levels
    reg [1:0] current_level, prev_level;

    // Determine current water level (combinational)
    always @(*) begin
        casez (s)
            3'b111: current_level = 2'b00;  // Above s[2]
            3'b011: current_level = 2'b01;  // Between s[2] and s[1]
            3'b001: current_level = 2'b10;  // Between s[1] and s[0]
            3'b000: current_level = 2'b11;  // Below s[0]
            default: current_level = 2'b11;  // Default to below s[0] for invalid patterns
        endcase
    end

    // Update state and outputs (sequential)
    always @(posedge clk) begin
        if (reset) begin
            // Reset to "below s[0]" state with all outputs asserted
            prev_level <= 2'b11;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Update previous level first
            prev_level <= current_level;

            // Set nominal flow rates based on current level
            case (current_level)
                2'b00: {fr2, fr1, fr0} <= 3'b000; // Above s[2]
                2'b01: {fr2, fr1, fr0} <= 3'b001; // Between s[2] and s[1]
                2'b10: {fr2, fr1, fr0} <= 3'b011; // Between s[1] and s[0]
                2'b11: {fr2, fr1, fr0} <= 3'b111; // Below s[0]
            endcase

            // Set supplemental flow (rising transition)
            dfr <= (current_level > prev_level);
        end
    end

endmodule