module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameters for maximum values
parameter MAX_SEC = 6'd59;
parameter MAX_MIN = 6'd59;
parameter MAX_HOUR = 5'd23;

// State encoding
typedef enum logic [1:0] {
    IDLE,
    SEC_INC,
    MIN_INC,
    HOUR_INC
} state_t;

state_t current_state, next_state;

// Next value registers
reg [5:0] next_sec;
reg [5:0] next_min;
reg [4:0] next_hour; // Only need 5 bits for 0-23

// Tick signal (pulses every second)
wire tick = (current_state != IDLE);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        current_state <= IDLE;
    end else begin
        // Update current state
        current_state <= next_state;
        
        // Update counters only when tick is active
        if (tick) begin
            Secs <= next_sec;
            Mins <= next_min;
            Hours <= {1'b0, next_hour};
        end
    end
end

// Next state and output logic
always @(*) begin
    // Default values
    next_state = IDLE;
    next_sec = Secs;
    next_min = Mins;
    next_hour = Hours[4:0];
    
    // State transitions and pre-computation
    case (current_state)
        IDLE: begin
            next_state = SEC_INC;
            next_sec = (Secs == MAX_SEC) ? 6'd0 : Secs + 1;
        end
        
        SEC_INC: begin
            if (Secs == MAX_SEC) begin
                next_state = MIN_INC;
                next_min = (Mins == MAX_MIN) ? 6'd0 : Mins + 1;
            end else begin
                next_state = IDLE;
            end
        end
        
        MIN_INC: begin
            if (Mins == MAX_MIN && Secs == MAX_SEC) begin
                next_state = HOUR_INC;
                next_hour = (Hours[4:0] == MAX_HOUR) ? 5'd0 : Hours[4:0] + 1;
            end else begin
                next_state = IDLE;
            end
        end
        
        HOUR_INC: begin
            next_state = IDLE;
        end
    endcase
end

endmodule