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
    localparam STATE_ABOVE_S2   = 2'd0;  // Highest level
    localparam STATE_BTW_S2_S1  = 2'd1;
    localparam STATE_BTW_S1_S0  = 2'd2;
    localparam STATE_BELOW_S0   = 2'd3;  // Lowest level

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic - explicitly handle all sensor combinations
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_S2;    // All sensors on
            3'b011:  next_state = STATE_BTW_S2_S1;   // s[0] and s[1] on
            3'b001:  next_state = STATE_BTW_S1_S0;   // Only s[0] on
            3'b000:  next_state = STATE_BELOW_S0;    // No sensors on
            // Handle invalid sensor combinations by maintaining current state
            default: next_state = current_state;
        endcase
    end

    // State register and output update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
            // Directly control outputs during reset
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            
            // Output logic - more efficient implementation
            case (current_state)
                STATE_ABOVE_S2:   {fr2, fr1, fr0} <= 3'b000;
                STATE_BTW_S2_S1:  {fr2, fr1, fr0} <= 3'b001;
                STATE_BTW_S1_S0:  {fr2, fr1, fr0} <= 3'b011;
                STATE_BELOW_S0:   {fr2, fr1, fr0} <= 3'b111;
            endcase
            
            // dfr is 1 when previous state was numerically higher (lower water level)
            dfr <= (prev_state > current_state);
        end
    end

endmodule