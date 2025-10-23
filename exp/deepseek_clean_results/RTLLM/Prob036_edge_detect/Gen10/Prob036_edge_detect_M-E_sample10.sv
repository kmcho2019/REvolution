module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

typedef enum logic [1:0] {
    IDLE,
    RISE_DETECTED,
    FALL_DETECTED
} state_t;

state_t current_state, next_state;
reg a_prev;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        a_prev <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end
    else begin
        current_state <= next_state;
        a_prev <= a;
        
        // Output logic
        rise <= (next_state == RISE_DETECTED);
        down <= (next_state == FALL_DETECTED);
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (~a_prev & a)       next_state = RISE_DETECTED;
            else if (a_prev & ~a)  next_state = FALL_DETECTED;
            else                  next_state = IDLE;
        end
        RISE_DETECTED: begin
            if (a_prev & ~a)       next_state = FALL_DETECTED;
            else                   next_state = IDLE;
        end
        FALL_DETECTED: begin
            if (~a_prev & a)       next_state = RISE_DETECTED;
            else                   next_state = IDLE;
        end
        default:                   next_state = IDLE;
    endcase
end

endmodule