module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding: higher number = lower water level
    localparam STATE_ABOVE_S2   = 2'd0;  // All sensors on (highest level)
    localparam STATE_BTW_S2_S1  = 2'd1;  // s[0] and s[1] on
    localparam STATE_BTW_S1_S0  = 2'd2;  // Only s[0] on
    localparam STATE_BELOW_S0   = 2'd3;  // No sensors on (lowest level)

    reg [1:0] current_state, next_state, prev_state;

    // Complete state transition logic - handles all 8 sensor combinations
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_S2;    // All sensors on
            3'b110:  next_state = STATE_ABOVE_S2;    // s[1] and s[2] on (treat as above s2)
            3'b101:  next_state = STATE_BTW_S2_S1;   // s[0] and s[2] on (invalid, treat as between s2-s1)
            3'b100:  next_state = STATE_BTW_S2_S1;   // Only s[2] on (invalid, treat as between s2-s1)
            3'b011:  next_state = STATE_BTW_S2_S1;   // s[0] and s[1] on
            3'b010:  next_state = STATE_BTW_S1_S0;   // Only s[1] on (invalid, treat as between s1-s0)
            3'b001:  next_state = STATE_BTW_S1_S0;   // Only s[0] on
            3'b000:  next_state = STATE_BELOW_S0;    // No sensors on
            default: next_state = current_state;     // Fallback (shouldn't occur)
        endcase
    end

    // State register and output update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
            // All flow outputs on, dfr off during reset
            {fr2, fr1, fr0, dfr} <= 4'b1110;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Output logic based on current state
            case (current_state)
                STATE_ABOVE_S2:   {fr2, fr1, fr0} <= 3'b000;
                STATE_BTW_S2_S1:  {fr2, fr1, fr0} <= 3'b001;
                STATE_BTW_S1_S0:  {fr2, fr1, fr0} <= 3'b011;
                STATE_BELOW_S0:   {fr2, fr1, fr0} <= 3'b111;
            endcase
            
            // dfr is 1 only when moving to higher level (lower state number)
            dfr <= (prev_state > current_state);
        end
    end

endmodule