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

    parameter IDLE_LEFT = 0;
    parameter IDLE_RIGHT = 1;
    parameter FALLING = 2;
    parameter DIGGING = 3;
    parameter SPLATTERED = 4;

    reg [2:0] state;
    reg [2:0] nextState;
    reg [4:0] fall_counter;
    reg fall_counter_enable;
    reg [2:0] prev_state;

    always @(*) begin
        case(state)
            IDLE_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            IDLE_RIGHT: begin
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
            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= IDLE_LEFT;
            fall_counter <= 0;
            prev_state <= IDLE_LEFT;
        end else begin
            case(state)
                IDLE_LEFT: begin
                    if(~ground) begin
                        nextState <= FALLING;
                        fall_counter_enable <= 1;
                        prev_state <= IDLE_LEFT;
                    end else if(dig) begin
                        nextState <= DIGGING;
                    end else if(bump_left) begin
                        nextState <= IDLE_RIGHT;
                    end else if(bump_right) begin
                        nextState <= IDLE_LEFT;
                    end else begin
                        nextState <= IDLE_LEFT;
                    end
                end
                IDLE_RIGHT: begin
                    if(~ground) begin
                        nextState <= FALLING;
                        fall_counter_enable <= 1;
                        prev_state <= IDLE_RIGHT;
                    end else if(dig) begin
                        nextState <= DIGGING;
                    end else if(bump_left) begin
                        nextState <= IDLE_LEFT;
                    end else if(bump_right) begin
                        nextState <= IDLE_RIGHT;
                    end else begin
                        nextState <= IDLE_RIGHT;
                    end
                end
                FALLING: begin
                    if(ground) begin
                        if(fall_counter > 20) begin
                            nextState <= SPLATTERED;
                        end else if(prev_state == IDLE_LEFT) begin
                            nextState <= IDLE_LEFT;
                        end else begin
                            nextState <= IDLE_RIGHT;
                        end
                        fall_counter <= 0;
                        fall_counter_enable <= 0;
                    end else begin
                        nextState <= FALLING;
                    end
                end
                DIGGING: begin
                    if(~ground) begin
                        nextState <= FALLING;
                        fall_counter_enable <= 1;
                        prev_state <= DIGGING;
                    end else begin
                        nextState <= DIGGING;
                    end
                end
                SPLATTERED: begin
                    nextState <= SPLATTERED;
                end
                default: begin
                    nextState <= IDLE_LEFT;
                end
            endcase
            if(fall_counter_enable) begin
                fall_counter <= fall_counter + 1;
            end
            state <= nextState;
        end
    end
endmodule