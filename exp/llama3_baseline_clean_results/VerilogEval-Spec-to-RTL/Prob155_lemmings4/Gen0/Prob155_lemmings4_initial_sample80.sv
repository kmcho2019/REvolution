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

reg [4:0] fall_counter; // counter to keep track of falling time
reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg walk_dir; // 0: left, 1: right

// initial state
initial begin
    state = 0; // WALK_LEFT
    walk_dir = 0; // left
    fall_counter = 0;
end

// state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = 0; // WALK_LEFT
        walk_dir = 0; // left
        fall_counter = 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    state = 2; // FALLING
                    fall_counter = 1;
                end else if (dig) begin
                    state = 3; // DIGGING
                end else if (bump_left) begin
                    walk_dir = 1; // right
                    state = 1; // WALK_RIGHT
                end else if (bump_right) begin
                    walk_dir = 0; // left
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    state = 2; // FALLING
                    fall_counter = 1;
                end else if (dig) begin
                    state = 3; // DIGGING
                end else if (bump_left) begin
                    walk_dir = 0; // left
                    state = 0; // WALK_LEFT
                end else if (bump_right) begin
                    walk_dir = 1; // right
                end
            end
            2: begin // FALLING
                fall_counter = fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state = 4; // SPLATTERED
                    end else begin
                        state = walk_dir ? 1 : 0; // resume walking
                    end
                    fall_counter = 0;
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state = 2; // FALLING
                    fall_counter = 1;
                end
            end
            4: begin // SPLATTERED
                // do nothing
            end
        endcase
    end
end

// output logic
assign walk_left = (state == 0 && !areset) || (state == 3 && walk_dir == 0 && !areset);
assign walk_right = (state == 1 && !areset) || (state == 3 && walk_dir == 1 && !areset);
assign aaah = (state == 2 && !areset);
assign digging = (state == 3 && !areset);

endmodule