module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

typedef enum logic [1:0] {
    COUNT_SEC,
    COUNT_MIN,
    COUNT_HOUR
} state_t;

state_t current_state, next_state;
reg [5:0] counter;
wire [5:0] counter_next;
wire counter_rollover;

// Counter logic
assign counter_next = (counter_rollover) ? 6'd0 : counter + 6'd1;
assign counter_rollover = (current_state == COUNT_HOUR) ? 
                         (counter == 6'd23) : (counter == 6'd59);

// State machine
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= COUNT_SEC;
        counter <= 6'd0;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        current_state <= next_state;
        counter <= counter_next;
        
        // Capture outputs
        case (current_state)
            COUNT_SEC:  Secs <= counter_next;
            COUNT_MIN:  Mins <= counter_next;
            COUNT_HOUR: Hours <= counter_next;
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    
    case (current_state)
        COUNT_SEC: if (counter_rollover) next_state = COUNT_MIN;
        COUNT_MIN: if (counter_rollover) next_state = COUNT_HOUR;
        COUNT_HOUR: if (counter_rollover) next_state = COUNT_SEC;
    endcase
end

endmodule