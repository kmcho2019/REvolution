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

    reg [1:0] state;
    reg [4:0] fall_count;
    reg was_walking_left;

    // States
    localparam WALKING = 2'b00;
    localparam FALLING = 2'b01;
    localparam DIGGING = 2'b10;
    localparam SPLATTERED = 2'b11;

    // Outputs for each state
    always @(*) begin
        case(state)
            WALKING: begin
                walk_left = was_walking_left;
                walk_right = ~was_walking_left;
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
                walk_left = was_walking_left;
                walk_right = ~was_walking_left;
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

    // State transitions
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALKING;
            fall_count <= 5'd0;
            was_walking_left <= 1;
        end
        else begin
            case(state)
                WALKING: begin
                    if(!ground) begin
                        state <= FALLING;
                        was_walking_left <= was_walking_left;
                    end
                    else if(dig) begin
                        state <= DIGGING;
                        was_walking_left <= was_walking_left;
                    end
                    else if(bump_left) begin
                        state <= WALKING;
                        was_walking_left <= 0;
                    end
                    else if(bump_right) begin
                        state <= WALKING;
                        was_walking_left <= 1;
                    end
                    else begin
                        state <= WALKING;
                        was_walking_left <= was_walking_left;
                    end
                end
                FALLING: begin
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 5'd20) begin
                            state <= SPLATTERED;
                        end
                        else begin
                            state <= WALKING;
                        end
                        fall_count <= 5'd0;
                    end
                    else begin
                        state <= FALLING;
                    end
                end
                DIGGING: begin
                    if(!ground) begin
                        state <= FALLING;
                        fall_count <= 5'd0;
                    end
                    else begin
                        state <= DIGGING;
                    end
                end
                SPLATTERED: begin
                    state <= SPLATTERED;
                end
                default: begin
                    state <= WALKING;
                    fall_count <= 5'd0;
                    was_walking_left <= 1;
                end
            endcase
        end
    end

endmodule