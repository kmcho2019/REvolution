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

    // Continuous level detection
    wire [1:0] water_level = s[2] ? 2'b11 :    // Above s[2]
                            s[1] ? 2'b10 :    // Between s[2]-s[1]
                            s[0] ? 2'b01 :    // Between s[1]-s[0]
                                   2'b00;     // Below s[0]

    always @(posedge clk) begin
        if (reset) begin
            // Reset to all outputs high (max flow)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            current_level <= 2'b00;
            prev_level <= 2'b00;
        end else begin
            // Update level history
            prev_level <= current_level;
            current_level <= water_level;

            // Set flow rates based on current level
            case(water_level)
                2'b00: {fr2, fr1, fr0} <= 3'b111;  // Below s[0]
                2'b01: {fr2, fr1, fr0} <= 3'b011;  // Between s[1]-s[0]
                2'b10: {fr2, fr1, fr0} <= 3'b001;  // Between s[2]-s[1]
                2'b11: {fr2, fr1, fr0} <= 3'b000;  // Above s[2]
            endcase

            // Supplemental flow when level is rising
            dfr <= (current_level > prev_level) ? 1'b1 :
                   (current_level < prev_level) ? 1'b0 :
                   dfr;  // Maintain previous state
        end
    end

endmodule