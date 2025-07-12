module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    // Default outputs
    rise = 1'b0;
    down = 1'b0;
    next_state = current_state;

    case (current_state)
        IDLE: begin
            if (a) begin
                next_state = RISING;
                rise = 1'b1;
            end else if (~a) begin
                next_state = FALLING;
                down = 1'b1;
            end
        end
        
        RISING: begin
            if (~a) begin
                next_state = FALLING;
                down = 1'b1;
            end else begin
                next_state = IDLE;
            end
        end
        
        FALLING: begin
            if (a) begin
                next_state = RISING;
                rise = 1'b1;
            end else begin
                next_state = IDLE;
            end
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule