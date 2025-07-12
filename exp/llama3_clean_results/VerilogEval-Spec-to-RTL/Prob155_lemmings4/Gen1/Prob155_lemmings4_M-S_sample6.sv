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
    reg prev_ground;
    reg prev_state;

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
                    else if(prev_state == WALK_LEFT) next_state = WALK_LEFT;
                    else if(prev_state == WALK_RIGHT) next_state = WALK_RIGHT;
                end
            end
            DIGGING: begin
                digging = 1;
                if(!ground) next_state = FALLING;
            end
            SPLATTERED: ;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
            prev_ground <= 1;
            prev_state <= WALK_LEFT;
        end else begin
            if(ground) begin
                if(prev_ground == 0) begin
                    if(fall_count > 20) state <= SPLATTERED;
                    else state <= prev_state;
                end else begin
                    state <= next_state;
                end
            end else begin
                state <= next_state;
                if(state == FALLING) fall_count <= fall_count + 1;
                else fall_count <= 0;
            end
            prev_ground <= ground;
            prev_state <= state;
        end
    end
endmodule