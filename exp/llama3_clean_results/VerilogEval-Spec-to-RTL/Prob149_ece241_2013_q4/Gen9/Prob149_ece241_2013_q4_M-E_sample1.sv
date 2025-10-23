module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Outer layer FSM states
reg [1:0] water_level;
reg prev_water_level;

// Inner layer FSM states
reg level_increasing;

// Sequential logic to update outer layer FSM states
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        water_level <= 2'b11;
        prev_water_level <= 2'b11;
        level_increasing <= 1'b0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b111: // Above s[2]
                water_level <= 2'b00;
            3'b110, 3'b101, 3'b011: // Between s[2] and s[1]
                water_level <= 2'b01;
            3'b100, 3'b010: // Between s[1] and s[0]
                water_level <= 2'b10;
            default: // Below s[0]
                water_level <= 2'b11;
        endcase

        // Update previous water level
        prev_water_level <= water_level;

        // Update inner layer FSM states
        if (water_level > prev_water_level) begin
            level_increasing <= 1'b1;
        end else if (water_level < prev_water_level) begin
            level_increasing <= 1'b0;
        end

        // Update output signals based on outer layer FSM states and inner layer FSM states
        case (water_level)
            2'b00: // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            2'b01: // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increasing;
            2'b10: // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increasing;
            2'b11: // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increasing;
        endcase
    end
end

endmodule