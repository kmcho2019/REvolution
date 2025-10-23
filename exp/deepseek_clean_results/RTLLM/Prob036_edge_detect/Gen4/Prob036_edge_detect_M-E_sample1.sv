module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state_t;

reg a_prev;
state_t current_state, next_state;

// Previous value storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_prev <= 1'b0;
    end else begin
        a_prev <= a;
    end
end

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (a_prev == 0 && a == 1)
                next_state = RISING;
            else if (a_prev == 1 && a == 0)
                next_state = FALLING;
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic (Moore style - outputs depend only on state)
always @(*) begin
    rise = (current_state == RISING);
    down = (current_state == FALLING);
end

endmodule