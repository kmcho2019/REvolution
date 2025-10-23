module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray-coded state definition
localparam [1:0] SEC_STATE  = 2'b00,
                 MIN_STATE  = 2'b01,
                 HOUR_STATE = 2'b11;

reg [1:0] current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        SEC_STATE:  next_state = (Secs == 6'd59) ? MIN_STATE : SEC_STATE;
        MIN_STATE:  next_state = (Mins == 6'd59) ? HOUR_STATE : SEC_STATE;
        HOUR_STATE: next_state = SEC_STATE;
        default:    next_state = SEC_STATE;
    endcase
end

// Counter update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        current_state <= SEC_STATE;
    end else begin
        current_state <= next_state;
        
        case (current_state)
            SEC_STATE: begin
                Secs <= (Secs == 6'd59) ? 6'd0 : Secs + 1;
                if (Secs == 6'd59) Mins <= (Mins == 6'd59) ? 6'd0 : Mins + 1;
            end
            
            MIN_STATE: begin
                if (Mins == 6'd59) Hours <= (Hours == 6'd23) ? 6'd0 : Hours + 1;
            end
            
            HOUR_STATE: begin
                // State transition only - counters handled in other states
            end
        endcase
    end
end

endmodule