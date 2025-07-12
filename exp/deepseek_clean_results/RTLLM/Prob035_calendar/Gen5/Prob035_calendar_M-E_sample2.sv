module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Internal state machine states
typedef enum logic [1:0] {
    IDLE,
    SEC_ROLL,
    MIN_ROLL,
    HOUR_ROLL
} state_t;

// Internal registers
reg [1:0] state, next_state;
reg [4:0] hours_int;  // 5-bit for 0-23
reg sec_roll_reg, min_roll_reg;

// Rollover detection (combinational)
wire sec_roll = (Secs == 6'd59);
wire min_roll = (Mins == 6'd59) & sec_roll_reg;
wire hour_roll = (hours_int == 5'd23) & min_roll_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters and state
        Secs <= 6'd0;
        Mins <= 6'd0;
        hours_int <= 5'd0;
        state <= IDLE;
        sec_roll_reg <= 1'b0;
        min_roll_reg <= 1'b0;
    end else begin
        // Pipeline rollover flags
        sec_roll_reg <= sec_roll;
        min_roll_reg <= min_roll;
        
        // State machine implementation
        case (state)
            IDLE: begin
                Secs <= Secs + 6'd1;
                if (sec_roll) state <= SEC_ROLL;
            end
            
            SEC_ROLL: begin
                Secs <= 6'd0;
                Mins <= min_roll ? 6'd0 : Mins + 6'd1;
                state <= min_roll ? MIN_ROLL : IDLE;
            end
            
            MIN_ROLL: begin
                hours_int <= hour_roll ? 5'd0 : hours_int + 5'd1;
                state <= hour_roll ? HOUR_ROLL : IDLE;
            end
            
            HOUR_ROLL: begin
                state <= IDLE;
            end
        endcase
    end
end

// Zero-pad hours output
always @(*) begin
    Hours = {1'b0, hours_int};
end

endmodule