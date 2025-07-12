module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
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

    // Transition detection
    assign level_rising = (detected_level > prev_level);

    // Level registers
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LVL_BELOW_S0;
            prev_level <= LVL_BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= detected_level;
        end
    end

    // Output logic (combinatorial)
    assign fr0 = (current_level == LVL_BELOW_S0) || 
                 (current_level == LVL_BTW_S0_S1) || 
                 (current_level == LVL_BTW_S1_S2);

    assign fr1 = (current_level == LVL_BELOW_S0) || 
                 (current_level == LVL_BTW_S0_S1);

    assign fr2 = (current_level == LVL_BELOW_S0);

    assign dfr = level_rising && 
                (current_level != LVL_ABOVE_S2) && 
                (current_level != LVL_BELOW_S0);

endmodule