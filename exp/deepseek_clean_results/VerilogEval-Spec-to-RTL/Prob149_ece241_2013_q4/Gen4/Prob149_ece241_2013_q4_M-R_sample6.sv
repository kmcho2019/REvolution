module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Current and previous water level (0=lowest, 3=highest)
    reg [1:0] current_level, prev_level;

    // Priority encoder - now 0=below s[0], 3=above s[2]
    wire [1:0] next_level = 
        (s == 3'b000) ? 2'b00 :  // Below s[0]
        (s == 3'b001) ? 2'b01 :  // Between s[1] and s[0]
        (s == 3'b011) ? 2'b10 :  // Between s[2] and s[1]
        2'b11;                   // Above s[2] or invalid

    // Track previous level for dfr calculation
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'b00; // Reset to below s[0]
            prev_level <= 2'b00;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
        end
    end

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            // All outputs asserted during reset
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Nominal flow rates
            fr0 <= (current_level <= 2'b10); // Levels 0,1,2
            fr1 <= (current_level <= 2'b01); // Levels 0,1
            fr2 <= (current_level == 2'b00); // Level 0 only
            
            // Supplemental flow (was level increasing?)
            dfr <= (current_level > prev_level);
        end
    end

endmodule