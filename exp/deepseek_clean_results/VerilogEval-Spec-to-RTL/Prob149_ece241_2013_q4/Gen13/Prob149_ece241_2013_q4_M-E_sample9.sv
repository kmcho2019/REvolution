module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Sensor history buffer (4 samples)
    reg [2:0] sensor_history [0:3];
    integer i;

    // Trend indicators
    reg rising, falling, stable;
    reg [1:0] trend_strength;

    // Time counter for current level
    reg [3:0] level_time;

    // Flow state
    reg [1:0] flow_state; // 00:min, 01:low, 10:med, 11:max

    always @(posedge clk) begin
        if (reset) begin
            // Initialize history buffer with all sensors off
            for (i = 0; i < 4; i = i + 1)
                sensor_history[i] <= 3'b000;
            
            rising <= 0;
            falling <= 0;
            stable <= 1;
            trend_strength <= 0;
            level_time <= 0;
            flow_state <= 2'b11; // Max flow
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Update sensor history
            sensor_history[0] <= s;
            for (i = 3; i > 0; i = i - 1)
                sensor_history[i] <= sensor_history[i-1];

            // Detect trend
            rising <= (sensor_history[0] > sensor_history[3]);
            falling <= (sensor_history[0] < sensor_history[3]);
            stable <= (sensor_history[0] == sensor_history[3]);
            
            // Calculate trend strength (0-3)
            trend_strength <= 
                (sensor_history[0] != sensor_history[1]) +
                (sensor_history[1] != sensor_history[2]) +
                (sensor_history[2] != sensor_history[3]);

            // Update level timer
            if (sensor_history[0] != sensor_history[1])
                level_time <= 0;
            else if (level_time != 4'b1111)
                level_time <= level_time + 1;

            // Determine flow state based on current sensors and history
            casez (s)
                3'b??1: begin // Above s[0]
                    if (s[2]) begin // Above s[2]
                        flow_state <= 2'b00; // No flow
                    end else if (s[1]) begin // Between s[2] and s[1]
                        flow_state <= 2'b01; // Low flow
                    end else begin // Between s[1] and s[0]
                        flow_state <= 2'b10; // Medium flow
                    end
                end
                3'b000: flow_state <= 2'b11; // Below s[0] - max flow
                default: flow_state <= flow_state; // Maintain state
            endcase

            // Generate outputs
            case (flow_state)
                2'b00: {fr2, fr1, fr0} = 3'b000; // No flow
                2'b01: {fr2, fr1, fr0} = 3'b001; // Low flow
                2'b10: {fr2, fr1, fr0} = 3'b011; // Medium flow
                2'b11: {fr2, fr1, fr0} = 3'b111; // Max flow
            endcase

            // Supplemental flow (dfr) based on trend
            dfr <= rising && (trend_strength > 1) && (level_time < 4'b0100);
        end
    end

endmodule