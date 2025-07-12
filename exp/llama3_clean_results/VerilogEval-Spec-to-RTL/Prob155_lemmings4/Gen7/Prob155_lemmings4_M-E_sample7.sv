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
    } outer_state, next_outer_state;

    enum logic [1:0] {
        LEFT,
        RIGHT,
        DIG
    } inner_state, next_inner_state;

    reg [4:0] fall_count;
    reg walking_direction;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            outer_state <= WALKING;
            inner_state <= LEFT;
            fall_count <= 0;
            walking_direction <= 1'b1;
        end else begin
            case(outer_state)
                WALKING: begin
                    case(inner_state)
                        LEFT: begin
                            if(bump_right) begin
                                next_inner_state <= RIGHT;
                                walking_direction <= 1'b0;
                            end else if(dig) begin
                                next_inner_state <= DIG;
                            end else begin
                                next_inner_state <= LEFT;
                            end
                        end
                        RIGHT: begin
                            if(bump_left) begin
                                next_inner_state <= LEFT;
                                walking_direction <= 1'b1;
                            end else if(dig) begin
                                next_inner_state <= DIG;
                            end else begin
                                next_inner_state <= RIGHT;
                            end
                        end
                        DIG: begin
                            if(!ground) begin
                                next_outer_state <= FALLING;
                                next_inner_state <= LEFT;
                            end else begin
                                next_outer_state <= WALKING;
                                next_inner_state <= LEFT;
                            end
                        end
                    endcase
                    if(!ground) begin
                        next_outer_state <= FALLING;
                        next_inner_state <= LEFT;
                    end else begin
                        next_outer_state <= WALKING;
                    end
                end
                FALLING: begin
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 20) begin
                            next_outer_state <= SPLATTERED;
                        end else begin
                            next_outer_state <= WALKING;
                        end
                        fall_count <= 0;
                    end else begin
                        next_outer_state <= FALLING;
                    end
                end
                SPLATTERED: begin
                    next_outer_state <= SPLATTERED;
                end
            endcase
            outer_state <= next_outer_state;
            inner_state <= next_inner_state;
        end
    end

    always @(*) begin
        case(outer_state)
            WALKING: begin
                case(inner_state)
                    LEFT: begin
                        walk_left = 1;
                        walk_right = 0;
                        aaah = 0;
                        digging = 0;
                    end
                    RIGHT: begin
                        walk_left = 0;
                        walk_right = 1;
                        aaah = 0;
                        digging = 0;
                    end
                    DIG: begin
                        walk_left = 0;
                        walk_right = 0;
                        aaah = 0;
                        digging = 1;
                    end
                endcase
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
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