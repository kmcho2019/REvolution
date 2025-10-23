module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states
    localparam STATE_ABOVE_S2   = 2'b00;
    localparam STATE_BTW_S2_S1  = 2'b01;
    localparam STATE_BTW_S1_S0  = 2'b10;
    localparam STATE_BELOW_S0   = 2'b11;

    reg [1:0] current_state, next_state, prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_S2;    // All sensors on
            3'b011:  next_state = STATE_BTW_S2_S1;   // s[0] and s[1] on
            3'b001:  next_state = STATE_BTW_S1_S0;   // Only s[0] on
            default: next_state = STATE_BELOW_S0;    // No sensors on
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

    // Output logic
    assign fr0 = (current_state == STATE_BTW_S2_S1) || 
                 (current_state == STATE_BTW_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    
    assign fr1 = (current_state == STATE_BTW_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    
    assign fr2 = (current_state == STATE_BELOW_S0);

    // dfr is 1 when previous state was lower than current state
    assign dfr = ((prev_state == STATE_BELOW_S0 && current_state == STATE_BTW_S1_S0) ||
                 (prev_state == STATE_BELOW_S0 && current_state == STATE_BTW_S2_S1) ||
                 (prev_state == STATE_BELOW_S0 && current_state == STATE_ABOVE_S2) ||
                 (prev_state == STATE_BTW_S1_S0 && current_state == STATE_BTW_S2_S1) ||
                 (prev_state == STATE_BTW_S1_S0 && current_state == STATE_ABOVE_S2) ||
                 (prev_state == STATE_BTW_S2_S1 && current_state == STATE_ABOVE_S2));

endmodule