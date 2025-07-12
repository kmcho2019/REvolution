module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // More intuitive state encoding based on water level
    localparam LEVEL_BELOW    = 2'b00;  // Below s[0]
    localparam LEVEL_LOW      = 2'b01;  // Between s[1] and s[0]
    localparam LEVEL_MID      = 2'b10;  // Between s[2] and s[1]
    localparam LEVEL_ABOVE    = 2'b11;  // Above s[2]

    reg [1:0] current_level, next_level, prev_level;
    reg was_rising;  // Tracks if last transition was rising

    // State transition logic
    always @(*) begin
        casez(s)
            3'b000: next_level = LEVEL_BELOW;  // No sensors
            3'b001: next_level = LEVEL_LOW;    // Only s[0]
            3'b011: next_level = LEVEL_MID;    // s[0] and s[1]
            3'b111: next_level = LEVEL_ABOVE;  // All sensors
            default: next_level = current_level; // Invalid patterns
        endcase
    end

    // State register and level tracking
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW;
            prev_level <= LEVEL_BELOW;
            was_rising <= 1'b0;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
            // Track if level is rising (current > previous)
            was_rising <= (next_level > current_level);
        end
    end

    // Output logic - nominal flow rates
    assign fr0 = (current_level != LEVEL_ABOVE);
    assign fr1 = (current_level == LEVEL_LOW) || (current_level == LEVEL_BELOW);
    assign fr2 = (current_level == LEVEL_BELOW);
    
    // dfr asserted only when level is rising
    assign dfr = was_rising && (current_level != prev_level);

endmodule