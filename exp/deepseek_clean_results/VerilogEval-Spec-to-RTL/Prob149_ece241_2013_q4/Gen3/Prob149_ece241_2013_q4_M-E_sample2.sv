module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Sensor interpretation
    wire level_above_s2 = &s;
    wire level_above_s1 = &s[1:0];
    wire level_above_s0 = s[0];

    // Watermark registers
    reg [2:0] highest_level;
    reg [2:0] lowest_level;
    reg [2:0] prev_level;

    // Hysteresis control
    reg [1:0] stable_count;
    wire level_changed = (prev_level != s);

    always @(posedge clk) begin
        if (reset) begin
            highest_level <= 3'b000;
            lowest_level <= 3'b111;
            prev_level <= 3'b000;
            stable_count <= 0;
        end else begin
            prev_level <= s;
            
            // Update watermarks
            if (s > highest_level)
                highest_level <= s;
            if (s < lowest_level)
                lowest_level <= s;

            // Hysteresis counter
            if (level_changed)
                stable_count <= 0;
            else if (stable_count < 3)
                stable_count <= stable_count + 1;
        end
    end

    // Trend detection
    wire level_rising = (s > prev_level) && (stable_count == 0);
    wire level_falling = (s < prev_level) && (stable_count == 0);

    // Flow control logic
    assign fr0 = ~level_above_s2 && (level_above_s0 || level_rising);
    assign fr1 = ~level_above_s2 && (~level_above_s1 || (level_rising && level_above_s1));
    assign fr2 = ~(|s) || (level_falling && ~level_above_s0);
    assign dfr = level_rising && ~level_above_s2;

endmodule