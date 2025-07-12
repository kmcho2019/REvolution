module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    SEC_INCR,
    MIN_INCR
} state_t;

reg [1:0] current_state, next_state;
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours[4:0] == 5'd23);

// State transition logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = SEC_INCR;
        SEC_INCR: next_state = sec_max ? MIN_INCR : IDLE;
        MIN_INCR: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Counter update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
        
        // Always increment seconds unless in reset
        Secs <= (current_state == SEC_INCR) ? 
               (sec_max ? 6'd0 : Secs + 6'd1) : Secs;
        
        // Minutes increment only when seconds roll over
        if (current_state == MIN_INCR) begin
            Mins <= min_max ? 6'd0 : Mins + 6'd1;
            
            // Hours increment only when both minutes and seconds roll over
            if (min_max && sec_max) begin
                Hours <= {1'b0, hour_max ? 5'd0 : Hours[4:0] + 5'd1};
            end
        end
    end
end

endmodule