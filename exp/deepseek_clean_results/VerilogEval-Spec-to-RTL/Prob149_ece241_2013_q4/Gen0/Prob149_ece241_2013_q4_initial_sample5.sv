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
    localparam ABOVE_HIGH = 2'b00;
    localparam HIGH_MID   = 2'b01;
    localparam MID_LOW    = 2'b10;
    localparam BELOW_LOW  = 2'b11;
    
    reg [1:0] current_state, next_state;
    reg prev_was_lower;  // Flag to track if previous level was lower
    
    // State transition logic
    always @(*) begin
        case (current_state)
            ABOVE_HIGH: next_state = (s == 3'b111) ? ABOVE_HIGH :
                                    (s == 3'b011) ? HIGH_MID :
                                    (s == 3'b001) ? MID_LOW : BELOW_LOW;
            HIGH_MID:   next_state = (s == 3'b111) ? ABOVE_HIGH :
                                    (s == 3'b011) ? HIGH_MID :
                                    (s == 3'b001) ? MID_LOW : BELOW_LOW;
            MID_LOW:    next_state = (s == 3'b111) ? ABOVE_HIGH :
                                    (s == 3'b011) ? HIGH_MID :
                                    (s == 3'b001) ? MID_LOW : BELOW_LOW;
            BELOW_LOW:  next_state = (s == 3'b111) ? ABOVE_HIGH :
                                    (s == 3'b011) ? HIGH_MID :
                                    (s == 3'b001) ? MID_LOW : BELOW_LOW;
            default:    next_state = BELOW_LOW;
        endcase
    end
    
    // Previous level tracking
    always @(posedge clk) begin
        if (reset) begin
            prev_was_lower <= 1'b0;
        end else begin
            case ({current_state, next_state})
                {HIGH_MID, ABOVE_HIGH},
                {MID_LOW, HIGH_MID},
                {MID_LOW, ABOVE_HIGH},
                {BELOW_LOW, MID_LOW},
                {BELOW_LOW, HIGH_MID},
                {BELOW_LOW, ABOVE_HIGH}: prev_was_lower <= 1'b1;
                default: prev_was_lower <= 1'b0;
            endcase
        end
    end
    
    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_LOW;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Output logic
    assign fr0 = (reset) ? 1'b1 : 
                (current_state == HIGH_MID || 
                 current_state == MID_LOW || 
                 current_state == BELOW_LOW);
    
    assign fr1 = (reset) ? 1'b1 : 
                (current_state == MID_LOW || 
                 current_state == BELOW_LOW);
    
    assign fr2 = (reset) ? 1'b1 : 
                (current_state == BELOW_LOW);
    
    assign dfr = (reset) ? 1'b1 : prev_was_lower;
    
endmodule