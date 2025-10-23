module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding - higher values = higher water levels
    localparam LEVEL_BELOW_S0  = 2'b00;
    localparam LEVEL_BTW_S1_S0 = 2'b01;
    localparam LEVEL_BTW_S2_S1 = 2'b10;
    localparam LEVEL_ABOVE_S2  = 2'b11;

    reg [1:0] current_level, next_level, prev_level;

    // Level detection combinational logic
    always @(*) begin
        if (s[2])          next_level = LEVEL_ABOVE_S2;
        else if (s[1])     next_level = LEVEL_BTW_S2_S1;
        else if (s[0])     next_level = LEVEL_BTW_S1_S0;
        else               next_level = LEVEL_BELOW_S0;
    end

    // State update and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
            
            // Nominal flow outputs
            fr0 <= (next_level >= LEVEL_BTW_S1_S0);
            fr1 <= (next_level >= LEVEL_BTW_S1_S0);
            fr2 <= (next_level == LEVEL_BELOW_S0);
            
            // Supplemental flow (rising water)
            dfr <= (next_level > current_level);
        end
    end

endmodule