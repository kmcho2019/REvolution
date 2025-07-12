module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level encoding (higher value = higher water level)
    localparam LVL_BELOW_S0  = 2'd0; // No sensors
    localparam LVL_BTW_S0_S1 = 2'd1; // s[0] only
    localparam LVL_BTW_S1_S2 = 2'd2; // s[1:0]
    localparam LVL_ABOVE_S2  = 2'd3; // s[2:0]

    reg [1:0] current_level;
    reg [1:0] prev_level;
    wire [1:0] detected_level;
    wire level_rising;

    // Priority encoder for water level detection
    assign detected_level = s[2] ? LVL_ABOVE_S2 :
                           s[1] ? LVL_BTW_S1_S2 :
                           s[0] ? LVL_BTW_S0_S1 :
                                  LVL_BELOW_S0;

    // Level registers
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LVL_BELOW_S0;
            prev_level <= LVL_BELOW_S0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= current_level;
            current_level <= detected_level;
            
            // Nominal flow outputs
            fr0 <= (detected_level == LVL_BELOW_S0) || 
                   (detected_level == LVL_BTW_S0_S1) || 
                   (detected_level == LVL_BTW_S1_S2);
            
            fr1 <= (detected_level == LVL_BELOW_S0) || 
                   (detected_level == LVL_BTW_S0_S1);
            
            fr2 <= (detected_level == LVL_BELOW_S0);
            
            // Supplemental flow output - only when level is rising
            dfr <= (prev_level < detected_level);
        end
    end

endmodule