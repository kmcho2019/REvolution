module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameters for flexibility
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

// State encoding using gray code
typedef enum logic [1:0] {
    NORMAL  = 2'b00,
    SEC_ROLL = 2'b01,
    MIN_ROLL = 2'b11,
    HOUR_ROLL = 2'b10
} state_t;

reg [1:0] current_state, next_state;
reg [5:0] secs_next, mins_next;
reg [4:0] hours_next;
reg sec_en, min_en, hour_en;

// State transition logic
always @(*) begin
    next_state = current_state;
    sec_en = 1'b1;
    min_en = 1'b0;
    hour_en = 1'b0;
    
    case (current_state)
        NORMAL: begin
            if (Secs == SEC_MAX) next_state = SEC_ROLL;
        end
        SEC_ROLL: begin
            next_state = NORMAL;
            sec_en = 1'b0;
            min_en = 1'b1;
            if (Mins == MIN_MAX) next_state = MIN_ROLL;
        end
        MIN_ROLL: begin
            next_state = NORMAL;
            sec_en = 1'b0;
            min_en = 1'b0;
            hour_en = 1'b1;
            if (Hours[4:0] == HOUR_MAX) next_state = HOUR_ROLL;
        end
        HOUR_ROLL: begin
            next_state = NORMAL;
            sec_en = 1'b0;
            min_en = 1'b0;
            hour_en = 1'b0;
        end
    endcase
end

// Sequential logic with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= NORMAL;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        current_state <= next_state;
        
        // Seconds counter with gated clock enable
        if (sec_en) begin
            Secs <= (Secs == SEC_MAX) ? 6'd0 : Secs + 6'd1;
        end
        
        // Minutes counter with gated clock enable
        if (min_en) begin
            Mins <= (Mins == MIN_MAX) ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter with gated clock enable
        if (hour_en) begin
            Hours <= (Hours[4:0] == HOUR_MAX) ? 6'd0 : {1'b0, Hours[4:0] + 5'd1};
        end
    end
end

endmodule