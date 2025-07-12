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

    // Determine current water level
    always @(*) begin
        case (s)
            3'b111: current_level = 2'b00;  // Above s[2] (all sensors on)
            3'b011: current_level = 2'b01;  // Between s[2] and s[1]
            3'b001: current_level = 2'b10;  // Between s[1] and s[0]
            3'b000: current_level = 2'b11;  // Below s[0] (all sensors off)
            default: current_level = 2'b11;  // Handle unexpected patterns as below s[0]
        endcase
    end

    // Update state and outputs
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b11; // Below all sensors
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Update flow rates based on current level
            case (current_level)
                2'b00: {fr2, fr1, fr0} = 3'b000; // Above s[2] - no flow
                2'b01: {fr2, fr1, fr0} = 3'b001; // Between s[2] and s[1] - fr0 only
                2'b10: {fr2, fr1, fr0} = 3'b011; // Between s[1] and s[0] - fr0 and fr1
                2'b11: {fr2, fr1, fr0} = 3'b111; // Below s[0] - all flows
            endcase

            // Supplemental flow (dfr) is 1 when level is rising
            dfr <= (current_level > prev_level);

            // Store current level for next cycle
            prev_level <= current_level;
        end
    end

endmodule