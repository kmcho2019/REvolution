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

    enum logic [1:0] {
        WALKING,
        FALLING,
        SPLATTERED
    } state, next_state;

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
            fall_count <= fall_count + (state == FALLING);
            prev_walk_direction <= walk_direction;
            if (state == WALKING) begin
                if (bump_left && walk_direction) walk_direction <= 0;
                else if (bump_right && !walk_direction) walk_direction <= 1;
            end
            walk_left <= walk_direction;
            walk_right <= !walk_direction;
            if (dig && state == WALKING && ground) digging <= 1;
            else digging <= 0;
        end
    end

    always @(*) begin
        case(state)
            WALKING: begin
                if (!ground) next_state = FALLING;
                else if (dig && !ground) next_state = FALLING;
                else next_state = WALKING;
                aaah = 0;
            end
            FALLING: begin
                next_state = (ground && fall_count > 20) ? SPLATTERED : (ground ? WALKING : FALLING);
                aaah = 1;
            end
            SPLATTERED: begin
                next_state = SPLATTERED;
                aaah = 0;
            end
        endcase
    end

    always @(*) begin
        if (state == SPLATTERED) begin
            walk_left = 0;
            walk_right = 0;
            digging = 0;
        end else if (state == WALKING) begin
            walk_left = walk_direction;
            walk_right = !walk_direction;
        end else begin
            walk_left = 0;
            walk_right = 0;
        end
    end

endmodule