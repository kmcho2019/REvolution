module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

typedef enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

typedef enum logic {
    LEFT,
    RIGHT
} direction_t;

state_t state;
direction_t direction;
logic [4:0] fall_count;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
        fall_count <= 5'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    direction <= (bump_left) ? RIGHT : LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
        endcase
    end
end

always_comb begin
    walk_left = (state == WALKING && direction == LEFT);
    walk_right = (state == WALKING && direction == RIGHT);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

endmodule