module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define states
enum logic [2:0] {
    IDLE,
    WALKING,
    FALLING,
    DIGGING
} state, next_state;

reg [5:0] fall_counter;

// Sub-states for walking direction
enum logic {
    WALK_LEFT,
    WALK_RIGHT
} walk_direction;

// Modular counter for fall duration
module FallCounter(
    input clk,
    input reset,
    output reg [5:0] count
);
    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 6'b0;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule

FallCounter fall_counter_module(
    .clk(clk),
    .reset(~ground || areset),
    .count(fall_counter)
);

// State transition logic
always_comb begin
    case (state)
        IDLE: begin
            if (~areset) begin
                next_state = WALKING;
            end else begin
                next_state = IDLE;
            end
        end
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left && walk_direction == WALK_LEFT) begin
                walk_direction = WALK_RIGHT;
            end else if (bump_right && walk_direction == WALK_RIGHT) begin
                walk_direction = WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 6'd20) begin
                    next_state = IDLE; // Splattered, reset to idle
                end else begin
                    next_state = WALKING;
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Update state
always_ff @(posedge clk) begin
    if (areset) begin
        state <= IDLE;
        walk_direction <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic
always_comb begin
    case (state)
        IDLE: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALKING: begin
            if (walk_direction == WALK_LEFT) begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end else begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule