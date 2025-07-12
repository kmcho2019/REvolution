module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // 0: WALKING_LEFT, 1: WALKING_RIGHT, 2: FALLING, 3: DIGGING
reg [1:0] next_state;

always @(*) begin
    case(state)
        0: begin // WALKING_LEFT
            if(~ground) next_state = 2; // FALLING
            else if(dig) next_state = 3; // DIGGING
            else if(bump_left) next_state = 1; // WALKING_RIGHT
            else next_state = 0; // WALKING_LEFT
        end
        1: begin // WALKING_RIGHT
            if(~ground) next_state = 2; // FALLING
            else if(dig) next_state = 3; // DIGGING
            else if(bump_right) next_state = 0; // WALKING_LEFT
            else next_state = 1; // WALKING_RIGHT
        end
        2: begin // FALLING
            if(ground) begin
                if(state == 2) begin // if we were falling, we need to keep the original direction
                    if(bump_left) next_state = 1; // WALKING_RIGHT
                    else if(bump_right) next_state = 0; // WALKING_LEFT
                    else next_state = state == 2 ? (bump_left ? 1 : 0) : state;
                end
                else next_state = state == 2 ? (bump_left ? 1 : 0) : state;
            end
            else next_state = 2; // FALLING
        end
        3: begin // DIGGING
            if(~ground) next_state = 2; // FALLING
            else next_state = 3; // DIGGING
        end
        default: next_state = 0; // WALKING_LEFT
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) state <= 0; // WALKING_LEFT
    else state <= next_state;
end

always @(*) begin
    case(state)
        0: begin // WALKING_LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // WALKING_RIGHT
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // FALLING
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // DIGGING
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule