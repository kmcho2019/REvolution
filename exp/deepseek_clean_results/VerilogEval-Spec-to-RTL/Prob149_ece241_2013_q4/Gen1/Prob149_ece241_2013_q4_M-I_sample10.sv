module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding - numerical value represents height (0=highest)
    localparam STATE_ABOVE_S2   = 2'b00;  // Highest level
    localparam STATE_BTW_S2_S1  = 2'b01;
    localparam STATE_BTW_S1_S0  = 2'b10;
    localparam STATE_BELOW_S0   = 2'b11;  // Lowest level

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_S2;    // All sensors on
            3'b011:  next_state = STATE_BTW_S2_S1;   // s[0] and s[1] on
            3'b001:  next_state = STATE_BTW_S1_S0;   // Only s[0] on
            default: next_state = STATE_BELOW_S0;    // No sensors on (or invalid)
        endcase
    end

    // State register and previous state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Output logic with reset override
    always @(*) begin
        if (reset) begin
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Nominal flow outputs
            fr0 = (current_state >= STATE_BTW_S2_S1);
            fr1 = (current_state >= STATE_BTW_S1_S0);
            fr2 = (current_state == STATE_BELOW_S0);
            
            // Supplemental flow (dfr) when water level is rising
            dfr = (current_state > prev_state);
        end
    end

endmodule