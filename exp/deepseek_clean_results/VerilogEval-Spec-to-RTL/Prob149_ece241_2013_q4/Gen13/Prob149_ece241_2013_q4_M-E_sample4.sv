module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Priority encoded levels (highest active sensor)
    // 3 = above s[2], 2 = s[2], 1 = s[1], 0 = s[0], -1 = below all
    reg [2:0] current_level;
    reg [2:0] level_history [0:1]; // Two-stage history buffer

    // Priority encoder for level detection
    always @(*) begin
        casez (s)
            3'b??1: current_level = 0; // At least s[0]
            3'b?11: current_level = 1; // At least s[1]
            3'b111: current_level = 2; // At least s[2]
            default: current_level = 3; // Above s[2] (all sensors active)
        endcase
    end

    // History buffer and output generation
    always @(posedge clk) begin
        if (reset) begin
            level_history[0] <= 3'b111; // Below all (no sensors)
            level_history[1] <= 3'b111;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update history (shift register)
            level_history[1] <= level_history[0];
            level_history[0] <= current_level;

            // Nominal flow outputs
            fr0 <= (current_level < 3); // Below s[2]
            fr1 <= (current_level < 1); // Below s[1]
            fr2 <= (current_level == 3'b111); // Below s[0]

            // Supplemental flow (rising transition detected)
            dfr <= ((level_history[0] > level_history[1]) && 
                   (level_history[0] < 3)) ? 1'b1 : 1'b0;
        end
    end

endmodule