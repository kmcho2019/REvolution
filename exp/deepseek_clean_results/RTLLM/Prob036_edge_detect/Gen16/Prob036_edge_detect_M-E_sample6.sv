module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

typedef enum logic [1:0] {
    IDLE,
    RISING,
    FALLING,
    STABLE
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        rise <= 0;
        down <= 0;
    end else begin
        current_state <= next_state;
        
        // Output logic
        rise <= (next_state == RISING);
        down <= (next_state == FALLING);
    end
end

always @(*) begin
    case (current_state)
        IDLE: next_state = a ? STABLE : STABLE;
        STABLE: begin
            if (a && !rise) next_state = RISING;
            else if (!a && !down) next_state = FALLING;
            else next_state = STABLE;
        end
        RISING: next_state = STABLE;
        FALLING: next_state = STABLE;
        default: next_state = IDLE;
    endcase
end

endmodule