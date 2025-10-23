module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum {
    IDLE,
    PATTERN_WAIT,
    Y_MONITOR
} state_t;

// Internal signals
state_t current_state, next_state;
reg [1:0] pattern_counter;
reg [1:0] timeout_counter;
reg f_pulse;

// Pattern detection states
localparam PATTERN_1 = 2'b00;
localparam PATTERN_0 = 2'b01;
localparam PATTERN_1_AGAIN = 2'b10;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        pattern_counter <= PATTERN_1;
        timeout_counter <= 2'b0;
        f_pulse <= 1'b0;
    end
    else begin
        current_state <= next_state;
        
        // Pattern detection FSM
        case (pattern_counter)
            PATTERN_1: if (x) pattern_counter <= PATTERN_0;
            PATTERN_0: if (!x) pattern_counter <= PATTERN_1_AGAIN;
            PATTERN_1_AGAIN: if (x) pattern_counter <= PATTERN_1;
            default: pattern_counter <= PATTERN_1;
        endcase
        
        // Timeout counter for y monitoring
        if (current_state == Y_MONITOR && !y)
            timeout_counter <= timeout_counter + 1;
        else
            timeout_counter <= 2'b0;
            
        // Generate f pulse (one cycle after reset)
        f_pulse <= (current_state == IDLE);
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    
    case (current_state)
        IDLE: 
            if (resetn) next_state = PATTERN_WAIT;
            
        PATTERN_WAIT:
            if (pattern_counter == PATTERN_1_AGAIN && x)
                next_state = Y_MONITOR;
                
        Y_MONITOR:
            if (y || timeout_counter == 2'b10)
                next_state = IDLE; // Permanent state handled in output logic
    endcase
end

// Output generation
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end
    else begin
        // f output (single pulse after reset)
        f <= f_pulse;
        
        // g output logic
        case (current_state)
            IDLE: g <= 1'b0;
            PATTERN_WAIT: g <= 1'b0;
            Y_MONITOR: begin
                g <= 1'b1;
                if (y || timeout_counter == 2'b10)
                    g <= y; // Permanent value based on y
            end
        endcase
    end
end

endmodule