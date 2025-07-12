module calendar (
    input CLK,
    input RST,
    output reg [7:0] Hours,  // BCD: 8 bits (4 bits each for tens and units)
    output reg [7:0] Mins,   // BCD: 8 bits
    output reg [7:0] Secs    // BCD: 8 bits
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    MIN_INCR,
    HOUR_INCR
} state_t;

state_t current_state, next_state;

// BCD increment functions
function [7:0] bcd_incr(input [7:0] bcd);
    reg [3:0] units = bcd[3:0];
    reg [3:0] tens = bcd[7:4];
    
    if (units == 4'd9) begin
        units = 4'd0;
        tens = tens + 4'd1;
    end else begin
        units = units + 4'd1;
    end
    
    // Handle rollover for different counters
    if ((tens == 4'd5 && units == 4'd9) ||  // Seconds/Minutes: 59->00
        (tens == 4'd2 && units == 4'd3))    // Hours: 23->00
    begin
        tens = 4'd0;
        units = 4'd0;
    end
    
    return {tens, units};
endfunction

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = (Secs == 8'h59) ? MIN_INCR : IDLE;
        MIN_INCR: next_state = (Mins == 8'h59) ? HOUR_INCR : IDLE;
        HOUR_INCR: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 8'h00;
        Mins <= 8'h00;
        Hours <= 8'h00;
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
        
        // Always increment seconds
        Secs <= bcd_incr(Secs);
        
        // Conditional increments
        case (current_state)
            MIN_INCR: begin
                Mins <= bcd_incr(Mins);
                if (next_state == HOUR_INCR) begin
                    Hours <= bcd_incr(Hours);
                end
            end
            HOUR_INCR: begin
                Hours <= bcd_incr(Hours);
            end
            default: ; // No additional actions
        endcase
    end
end

endmodule