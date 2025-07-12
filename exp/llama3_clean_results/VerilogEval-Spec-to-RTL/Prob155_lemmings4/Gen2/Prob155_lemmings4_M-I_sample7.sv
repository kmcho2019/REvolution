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

    enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTERED
    } state, next_state;

    reg [4:0] fall_count;
    reg prev_walk_dir;
    reg prev_ground;

    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1;
                if(bump_right) next_state = WALK_RIGHT;
                else if(dig && ground) next_state = DIGGING;
                else if(!ground) next_state = FALLING;
            end
            WALK_RIGHT: begin
                walk_right = 1;
                if(bump_left) next_state = WALK_LEFT;
                else if(dig && ground) next_state = DIGGING;
                else if(!ground) next_state = FALLING;
            end
            FALLING: begin
                aaah = 1;
                if(ground) begin
                    if(fall_count > 20) next_state = SPLATTERED;
                    else if(prev_walk_dir) next_state = WALK_LEFT;
                    else next_state = WALK_RIGHT;
                end
            end
            DIGGING: begin
                digging = 1;
                if(!ground) next_state = FALLING;
                else if(!dig) next_state = prev_walk_dir ? WALK_LEFT : WALK_RIGHT;
            end
            SPLATTERED: ;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
            prev_walk_dir <= 1;
            prev_ground <= 1;
        end else begin
            state <= next_state;
            if(!ground) fall_count <= fall_count + 1;
            else fall_count <= 0;
            prev_walk_dir <= (state == WALK_LEFT) ? 1 : (state == WALK_RIGHT) ? 0 : prev_walk_dir;
            prev_ground <= ground;
        end
    end
endmodule