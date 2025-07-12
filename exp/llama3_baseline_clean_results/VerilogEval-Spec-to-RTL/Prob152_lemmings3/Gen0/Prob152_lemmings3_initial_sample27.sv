module TopModule(
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

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALL, 3: DIG
reg [1:0] next_state;
reg previous_direction;

always @(*) begin
    case (state)
        0: begin // WALK_LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
            if (!ground) begin
                next_state = 2; // FALL
            end else if (dig) begin
                next_state = 3; // DIG
            end else if (bump_left) begin
                next_state = 1; // WALK_RIGHT
            end else if (bump_right) begin
                next_state = 0; // WALK_LEFT
            end else begin
                next_state = 0; // WALK_LEFT
            end
        end
        1: begin // WALK_RIGHT
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
            if (!ground) begin
                next_state = 2; // FALL
            end else if (dig) begin
                next_state = 3; // DIG
            end else if (bump_right) begin
                next_state = 0; // WALK_LEFT
            end else if (bump_left) begin
                next_state = 1; // WALK_RIGHT
            end else begin
                next_state = 1; // WALK_RIGHT
            end
        end
        2: begin // FALL
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
            if (ground) begin
                if (previous_direction == 0) begin
                    next_state = 0; // WALK_LEFT
                end else begin
                    next_state = 1; // WALK_RIGHT
                end
            end else begin
                next_state = 2; // FALL
            end
        end
        3: begin // DIG
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
            if (!ground) begin
                next_state = 2; // FALL
            end else begin
                next_state = 3; // DIG
            end
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
            next_state = 0; // WALK_LEFT
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        previous_direction <= 0;
    end else begin
        state <= next_state;
        if ((state == 0 || state == 1) && ground) begin
            previous_direction <= state;
        end
    end
end

endmodule