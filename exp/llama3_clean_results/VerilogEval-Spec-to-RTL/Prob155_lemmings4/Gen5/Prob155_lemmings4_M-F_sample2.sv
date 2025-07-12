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
    reg walking_direction;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
            walking_direction <= 1'b1; // 1 for left, 0 for right
        end else begin
            case(state)
                WALK_LEFT: begin
                    if(!ground) next_state <= FALLING;
                    else if(dig) next_state <= DIGGING;
                    else if(bump_right) begin
                        next_state <= WALK_RIGHT;
                        walking_direction <= 1'b0;
                    end
                    else next_state <= WALK_LEFT;
                end
                WALK_RIGHT: begin
                    if(!ground) next_state <= FALLING;
                    else if(dig) next_state <= DIGGING;
                    else if(bump_left) begin
                        next_state <= WALK_LEFT;
                        walking_direction <= 1'b1;
                    end
                    else next_state <= WALK_RIGHT;
                end
                FALLING: begin
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 20) next_state <= SPLATTERED;
                        else next_state <= walking_direction? WALK_LEFT : WALK_RIGHT;
                        fall_count <= 0; // Reset fall_count when hitting the ground
                    end else next_state <= FALLING;
                end
                DIGGING: begin
                    if(!ground) next_state <= FALLING;
                    else next_state <= DIGGING;
                end
                SPLATTERED: next_state <= SPLATTERED;
            endcase
            state <= next_state;
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