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
    localparam STATE_ABOVE_S2   = 2'd0;  // Highest level (all sensors on)
    localparam STATE_BTW_S2_S1  = 2'd1;  // s[2] off, s[1] and s[0] on
    localparam STATE_BTW_S1_S0  = 2'd2;  // s[2] and s[1] off, s[0] on
    localparam STATE_BELOW_S0   = 2'd3;  // No sensors on

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic - handle all 8 sensor combinations
    always @(*) begin
        case (s)
            3'b111: next_state = STATE_ABOVE_S2;    // All sensors on
            3'b110: next_state = STATE_ABOVE_S2;    // s[2] and s[1] on
            3'b101: next_state = STATE_ABOVE_S2;    // s[2] and s[0] on (invalid)
            3'b100: next_state = STATE_ABOVE_S2;    // Only s[2] on (invalid)
            3'b011: next_state = STATE_BTW_S2_S1;   // s[1] and s[0] on
            3'b010: next_state = STATE_BTW_S2_S1;    // Only s[1] on (invalid)
            3'b001: next_state = STATE_BTW_S1_S0;    // Only s[0] on
            3'b000: next_state = STATE_BELOW_S0;     // No sensors on
        endcase
    end

    // Output generation (combinational)
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0} = 3'b111;
            dfr = 1'b1;
        end else begin
            case (next_state)
                STATE_ABOVE_S2:   {fr2, fr1, fr0} = 3'b000;
                STATE_BTW_S2_S1:  {fr2, fr1, fr0} = 3'b001;
                STATE_BTW_S1_S0:  {fr2, fr1, fr0} = 3'b011;
                STATE_BELOW_S0:   {fr2, fr1, fr0} = 3'b111;
            endcase
            
            // dfr is 1 only when moving from lower to higher level
            dfr = (prev_state > current_state);
        end
    end

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

endmodule