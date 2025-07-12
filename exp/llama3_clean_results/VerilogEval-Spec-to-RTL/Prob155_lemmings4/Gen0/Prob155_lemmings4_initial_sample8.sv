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

    reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
    reg [4:0] fall_count; // Counter for the number of clock cycles the Lemming has been falling
    reg prev_ground; // Previous value of the ground signal

    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            0: begin // WALK_LEFT
                walk_left = 1;
            end
            1: begin // WALK_RIGHT
                walk_right = 1;
            end
            2: begin // FALLING
                aaah = 1;
            end
            3: begin // DIGGING
                digging = 1;
            end
            4: ; // SPLATTERED
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= 0;
            fall_count <= 0;
            prev_ground <= 1;
        end else begin
            if(ground) begin
                if(prev_ground == 0) begin // Ground has just appeared
                    if(fall_count > 20) begin // Lemming has splattered
                        state <= 4;
                    end else begin
                        case(state)
                            2: state <= 0; // Falling to walking left
                            default: ; // Do nothing
                        endcase
                    end
                end else begin
                    case(state)
                        0: begin // WALK_LEFT
                            if(bump_right) begin
                                state <= 1; // Switch to walking right
                            end else if(dig) begin
                                state <= 3; // Start digging
                            end
                        end
                        1: begin // WALK_RIGHT
                            if(bump_left) begin
                                state <= 0; // Switch to walking left
                            end else if(dig) begin
                                state <= 3; // Start digging
                            end
                        end
                        3: begin // DIGGING
                            if(!ground) begin
                                state <= 2; // Stop digging and start falling
                            end
                        end
                        default: ; // Do nothing
                    endcase
                end
            end else begin // No ground
                case(state)
                    0: state <= 2; // Walking left to falling
                    1: state <= 2; // Walking right to falling
                    2: begin // FALLING
                        fall_count <= fall_count + 1;
                    end
                    3: state <= 2; // Digging to falling
                    default: ; // Do nothing
                endcase
            end
            prev_ground <= ground;
        end
    end
endmodule