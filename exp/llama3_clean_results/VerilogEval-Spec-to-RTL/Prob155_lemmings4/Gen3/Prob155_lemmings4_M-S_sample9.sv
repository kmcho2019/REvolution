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
    reg prev_state;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
            prev_state <= WALK_LEFT;
        end else begin
            case(state)
                WALK_LEFT: begin
                    if(bump_right) next_state <= WALK_RIGHT;
                    else if(dig && ground) next_state <= DIGGING;
                    else if(!ground) next_state <= FALLING;
                    else next_state <= WALK_LEFT;
                end
                WALK_RIGHT: begin
                    if(bump_left) next_state <= WALK_LEFT;
                    else if(dig && ground) next_state <= DIGGING;
                    else if(!ground) next_state <= FALLING;
                    else next_state <= WALK_RIGHT;
                end
                FALLING: begin
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 20) next_state <= SPLATTERED;
                        else if(prev_state == WALK_LEFT) next_state <= WALK_LEFT;
                        else if(prev_state == WALK_RIGHT) next_state <= WALK_RIGHT;
                    end else next_state <= FALLING;
                end
                DIGGING: begin
                    if(!ground) next_state <= FALLING;
                    else next_state <= DIGGING;
                end
                SPLATTERED: next_state <= SPLATTERED;
            endcase
            state <= next_state;
            if(state == FALLING && ground) fall_count <= 0;
            if(ground && state != FALLING) fall_count <= 0;
            if(state != FALLING && state != DIGGING) prev_state <= state;
        end
    end

    always @(*) begin
        case(state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule