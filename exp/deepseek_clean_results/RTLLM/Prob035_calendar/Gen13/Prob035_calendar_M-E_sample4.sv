module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Constants
parameter MAX_SEC = 6'd59;
parameter MAX_MIN = 6'd59;
parameter MAX_HOUR = 5'd23;  // 5 bits sufficient

// State encoding
typedef enum logic [1:0] {
    NORMAL,
    SEC_ROLL,
    MIN_ROLL
} state_t;

// Internal signals
state_t state, next_state;
reg [5:0] secs_next, mins_next;
reg [4:0] hours_next;  // Internal hours (5 bits)
reg [5:0] hours_out;   // Output register (6 bits)

// Combinational next state and value logic
always @(*) begin
    // Default assignments
    next_state = NORMAL;
    secs_next = Secs + 1'b1;
    mins_next = Mins;
    hours_next = hours_out[4:0];
    
    // State transition and rollover logic
    case (state)
        NORMAL: begin
            if (Secs == MAX_SEC) begin
                next_state = SEC_ROLL;
                secs_next = 6'd0;
                mins_next = Mins + 1'b1;
            end
        end
        
        SEC_ROLL: begin
            if (Mins == MAX_MIN) begin
                next_state = MIN_ROLL;
                mins_next = 6'd0;
                hours_next = (hours_out[4:0] == MAX_HOUR) ? 5'd0 : hours_out[4:0] + 1'b1;
            end else begin
                next_state = NORMAL;
            end
        end
        
        MIN_ROLL: begin
            next_state = NORMAL;
        end
    endcase
end

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= NORMAL;
        Secs <= 6'd0;
        Mins <= 6'd0;
        hours_out <= 6'd0;
    end else begin
        state <= next_state;
        Secs <= secs_next;
        Mins <= mins_next;
        hours_out <= {1'b0, hours_next};
    end
end

// Output assignments with registered outputs
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        Hours <= hours_out;
        Mins <= Mins;
        Secs <= Secs;
    end
end

endmodule