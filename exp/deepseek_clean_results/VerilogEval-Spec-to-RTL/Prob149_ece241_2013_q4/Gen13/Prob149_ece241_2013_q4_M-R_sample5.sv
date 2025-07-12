module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding for water levels
    localparam LEVEL_ABOVE_S2  = 2'b00;
    localparam LEVEL_BTW_S2_S1 = 2'b01;
    localparam LEVEL_BTW_S1_S0 = 2'b10;
    localparam LEVEL_BELOW_S0  = 2'b11;

    reg [1:0] current_level, next_level, prev_level;

    // Level detection combinational logic
    always @(*) begin
        casez (s)
            3'b111:  next_level = LEVEL_ABOVE_S2;
            3'b011:  next_level = LEVEL_BTW_S2_S1;
            3'b001:  next_level = LEVEL_BTW_S1_S0;
            3'b000:  next_level = LEVEL_BELOW_S0;
            default: next_level = LEVEL_BELOW_S0; // Default to lowest level
        endcase
    end

    // State update and reset logic
    always @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW_S0;
            prev_level <= LEVEL_BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
        end
    end

    // Output logic - nominal flow rates
    assign fr0 = (current_level == LEVEL_BTW_S1_S0) || 
                 (current_level == LEVEL_BELOW_S0);
    assign fr1 = (current_level == LEVEL_BELOW_S0);
    assign fr2 = (current_level == LEVEL_BELOW_S0);

    // Supplemental flow (rising water)
    assign dfr = (current_level < prev_level); // Current level numerically higher

endmodule