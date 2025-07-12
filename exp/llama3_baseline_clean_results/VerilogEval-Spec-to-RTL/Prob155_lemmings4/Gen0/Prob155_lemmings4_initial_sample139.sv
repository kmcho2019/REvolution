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

reg [1:0] state; // 0: WALKING_LEFT, 1: WALKING_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [4:0] fall_count; // count the number of clock cycles the Lemming has been falling
reg prev_ground; // previous value of ground

// initialize the state machine
initial state = 0;
initial fall_count = 0;
initial prev_ground = 1;
initial walk_left = 1;
initial walk_right = 0;
initial aaah = 0;
initial digging = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        fall_count <= 0;
        prev_ground <= 1;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // WALKING_LEFT
                if (bump_left || bump_right) begin
                    if (bump_left) state <= 1; // switch to WALKING_RIGHT
                    else state <= 0; // switch to WALKING_LEFT
                end else if (!ground) begin
                    state <= 2; // transition to FALLING
                end else if (dig && ground) begin
                    state <= 3; // transition to DIGGING
                end
            end
            1: begin // WALKING_RIGHT
                if (bump_left || bump_right) begin
                    if (bump_right) state <= 0; // switch to WALKING_LEFT
                    else state <= 1; // switch to WALKING_RIGHT
                end else if (!ground) begin
                    state <= 2; // transition to FALLING
                end else if (dig && ground) begin
                    state <= 3; // transition to DIGGING
                end
            end
            2: begin // FALLING
                if (ground) begin
                    if (fall_count > 20) state <= 4; // splatter
                    else begin
                        if (prev_ground == 1) state <= 0; // resume walking left
                        else if (prev_ground == 0) state <= 1; // resume walking right
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state <= 2; // transition to FALLING
                end
            end
            4: begin // SPLATTERED
                // do nothing
            end
        endcase
        // update output signals
        case (state)
            0: begin
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            1: begin
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
                digging <= 0;
            end
            2: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
            end
            3: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
            end
            4: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
        // update prev_ground
        prev_ground <= ground;
    end
end

endmodule