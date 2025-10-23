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

    enum {WALKING, FALLING, DIGGING, SPLATTERED} state, next_state;

    reg [4:0] fall_count;
    reg walk_direction;
    reg prev_walk_direction;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALKING;
            fall_count <= 0;
            walk_direction <= 1;
            prev_walk_direction <= 1;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            state <= next_state;
            case(state)
                WALKING: begin
                    if (dig && ground) begin
                        fall_count <= 0;
                        walk_direction <= walk_direction;
                        prev_walk_direction <= walk_direction;
                        walk_left <= walk_direction;
                        walk_right <= !walk_direction;
                        aaah <= 0;
                        digging <= 1;
                    end else if (!ground) begin
                        fall_count <= 1;
                        walk_direction <= walk_direction;
                        prev_walk_direction <= walk_direction;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 1;
                        digging <= 0;
                    end else if (bump_left && walk_direction) begin
                        walk_direction <= 0;
                        prev_walk_direction <= walk_direction;
                        walk_left <= walk_direction;
                        walk_right <= !walk_direction;
                        aaah <= 0;
                        digging <= 0;
                    end else if (bump_right && !walk_direction) begin
                        walk_direction <= 1;
                        prev_walk_direction <= walk_direction;
                        walk_left <= walk_direction;
                        walk_right <= !walk_direction;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        fall_count <= fall_count;
                        walk_direction <= walk_direction;
                        prev_walk_direction <= walk_direction;
                        walk_left <= walk_direction;
                        walk_right <= !walk_direction;
                        aaah <= 0;
                        digging <= digging;
                    end
                end
                FALLING: begin
                    fall_count <= fall_count + 1;
                    walk_direction <= walk_direction;
                    prev_walk_direction <= walk_direction;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
                DIGGING: begin
                    if (!ground) begin
                        fall_count <= 1;
                        walk_direction <= walk_direction;
                        prev_walk_direction <= walk_direction;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 1;
                        digging <= 0;
                    end else begin
                        fall_count <= fall_count;
                        walk_direction <= walk_direction;
                        prev_walk_direction <= walk_direction;
                        walk_left <= walk_direction;
                        walk_right <= !walk_direction;
                        aaah <= 0;
                        digging <= 1;
                    end
                end
                SPLATTERED: begin
                    fall_count <= fall_count;
                    walk_direction <= walk_direction;
                    prev_walk_direction <= walk_direction;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            endcase
        end
    end

    integer threshold; // Introduced to hold the threshold value
    initial threshold = 20; // Initialize threshold

    always @(*) begin
        case(state)
            WALKING: next_state = (dig && ground) ? DIGGING : (!ground) ? FALLING : (bump_left && walk_direction || bump_right && !walk_direction) ? WALKING : WALKING;
            FALLING: next_state = (ground && fall_count >= threshold) ? SPLATTERED : (ground) ? WALKING : FALLING; // Use threshold for comparison
            DIGGING: next_state = (!ground) ? FALLING : DIGGING;
            SPLATTERED: next_state = SPLATTERED;
        endcase
    end

endmodule