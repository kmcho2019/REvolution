module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding
    localparam LEVEL_BELOW_S0  = 2'b00;  // No sensors
    localparam LEVEL_BTW_S1_S0 = 2'b01;  // s[0] only
    localparam LEVEL_BTW_S2_S1 = 2'b10;  // s[1] and s[0]
    localparam LEVEL_ABOVE_S2  = 2'b11;  // All sensors

    reg [1:0] current_level, next_level, prev_level;

    // Level detection combinational logic
    always @(*) begin
        casez (s)
            3'b??1: next_level = LEVEL_ABOVE_S2;    // s[2] asserted
            3'b?10: next_level = LEVEL_BTW_S2_S1;   // s[1] asserted
            3'b100: next_level = LEVEL_BTW_S1_S0;   // s[0] asserted
            default: next_level = LEVEL_BELOW_S0;   // No sensors
        endcase
    end

    // State update and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
            
            // Nominal flow outputs per specification table
            fr0 <= (next_level != LEVEL_ABOVE_S2);
            fr1 <= (next_level <= LEVEL_BTW_S1_S0);
            fr2 <= (next_level == LEVEL_BELOW_S0);
            
            // Supplemental flow (rising water detected)
            dfr <= (current_level > prev_level);
        end
    end

endmodule