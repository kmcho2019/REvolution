module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Current and previous highest active sensor
    reg [1:0] current_level, prev_level;
    reg level_changed;

    // Priority encoder for current water level
    always @(*) begin
        casez (s)
            3'b??1: current_level = 2'b00;  // At or above s[0]
            3'b?10: current_level = 2'b01;  // At or above s[1]
            3'b100: current_level = 2'b10;  // At or above s[2]
            3'b000: current_level = 2'b11;  // Below all sensors
            default: current_level = 2'b11; // Handle unexpected patterns
        endcase
    end

    // Track level changes and previous level
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b11; // Below all sensors
            level_changed <= 1'b0;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            level_changed <= (current_level != prev_level);
            prev_level <= current_level;

            // Nominal flow outputs
            case (current_level)
                2'b00: {fr2, fr1, fr0} = 3'b011; // Between s[1] and s[0]
                2'b01: {fr2, fr1, fr0} = 3'b001; // Between s[2] and s[1]
                2'b10: {fr2, fr1, fr0} = 3'b000; // Above s[2]
                2'b11: {fr2, fr1, fr0} = 3'b111; // Below s[0]
            endcase

            // Supplemental flow (dfr) logic
            if (level_changed) begin
                // Assert dfr only if level is rising (current_level > prev_level)
                dfr <= (current_level > prev_level);
            end else begin
                // Maintain dfr when level is stable
                dfr <= (current_level == 2'b11); // Only keep dfr high when below all sensors
            end
        end
    end

endmodule