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
    localparam STATE_ABOVE_S2  = 2'b00;
    localparam STATE_BTW_S2_S1 = 2'b01;
    localparam STATE_BTW_S1_S0 = 2'b10;
    localparam STATE_BELOW_S0  = 2'b11;

    reg [1:0] current_state, next_state;
    reg was_rising;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_ABOVE_S2: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BTW_S2_S1;
                else if (s == 3'b001) next_state = STATE_BTW_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            STATE_BTW_S2_S1: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BTW_S2_S1;
                else if (s == 3'b001) next_state = STATE_BTW_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            STATE_BTW_S1_S0: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BTW_S2_S1;
                else if (s == 3'b001) next_state = STATE_BTW_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            STATE_BELOW_S0: begin
                if (s == 3'b111) next_state = STATE_ABOVE_S2;
                else if (s == 3'b011) next_state = STATE_BTW_S2_S1;
                else if (s == 3'b001) next_state = STATE_BTW_S1_S0;
                else next_state = STATE_BELOW_S0;
            end
            default: next_state = STATE_BELOW_S0;
        endcase
    end

    // Rising detection logic
    always @(posedge clk) begin
        if (reset) begin
            was_rising <= 1'b0;
        end else begin
            case (current_state)
                STATE_ABOVE_S2: was_rising <= 1'b0;
                STATE_BTW_S2_S1: was_rising <= (next_state == STATE_ABOVE_S2);
                STATE_BTW_S1_S0: was_rising <= (next_state == STATE_ABOVE_S2 || next_state == STATE_BTW_S2_S1);
                STATE_BELOW_S0: was_rising <= (next_state != STATE_BELOW_S0);
            endcase
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
        end else begin
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
    
    assign dfr = was_rising && ((current_state == STATE_BTW_S2_S1) || 
                                (current_state == STATE_BTW_S1_S0) || 
                                (current_state == STATE_BELOW_S0));

endmodule