module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [1:0] {
    FALLING = 2'b00,
    WALKING = 2'b01,
    DIGGING = 2'b10
} state;

// Define the walking directions
enum logic [0:0] {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        if (!ground) begin
            state <= FALLING;
            aaah <= 1'b1;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            digging <= 1'b0;
        end else if (dig && state == WALKING) begin
            state <= DIGGING;
            digging <= 1'b1;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else if (state == FALLING) begin
            state <= WALKING;
            aaah <= 1'b0;
            if (walk_direction == LEFT) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            digging <= 1'b0;
        end else if (state == DIGGING) begin
            if (!ground) begin
                state <= FALLING;
                digging <= 1'b0;
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
            end
        end else if (bump_left && state == WALKING) begin
            walk_direction <= RIGHT;
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end else if (bump_right && state == WALKING) begin
            walk_direction <= LEFT;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
    end
end

endmodule