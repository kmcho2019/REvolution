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
        IDLE,
        WALKING,
        DIGGING,
        FALLING,
        SPLATTERED
    } state, next_state;

    reg [4:0] fall_count;
    reg walk_direction;

    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            IDLE: begin
                if(ground) next_state = WALKING;
            end
            WALKING: begin
                if(walk_direction) walk_left = 1;
                else walk_right = 1;
                if(bump_left && !walk_direction) walk_direction = 1;
                else if(bump_right && walk_direction) walk_direction = 0;
                else if(bump_left && bump_right) walk_direction = !walk_direction;
                if(dig && ground) next_state = DIGGING;
                else if(!ground) next_state = FALLING;
            end
            DIGGING: begin
                digging = 1;
                if(!ground) next_state = FALLING;
            end
            FALLING: begin
                aaah = 1;
                if(ground) begin
                    if(fall_count > 20) next_state = SPLATTERED;
                    else next_state = WALKING;
                end
            end
            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= IDLE;
            fall_count <= 0;
            walk_direction <= 1;
        end else begin
            state <= next_state;
            if(state == FALLING && next_state == FALLING) fall_count <= fall_count + 1;
            else if(state == FALLING && next_state != FALLING) fall_count <= 0;
            else fall_count <= 0;
        end
    end
endmodule