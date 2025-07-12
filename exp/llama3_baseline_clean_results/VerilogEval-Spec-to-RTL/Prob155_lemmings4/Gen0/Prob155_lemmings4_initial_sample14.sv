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

// Define states
localparam WALKING_LEFT = 4'b0000;
localparam WALKING_RIGHT = 4'b0001;
localparam FALLING = 4'b0010;
localparam DIGGING = 4'b0011;
localparam SPLATTERED = 4'b0100;

reg [3:0] current_state;
reg [3:0] next_state;

reg [5:0] fall_counter;

reg [1:0] direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING_LEFT;
        direction <= 0;
        fall_counter <= 0;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (current_state)
        WALKING_LEFT: begin
            walk_left = 1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                direction <= 1;
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                direction <= 0;
                next_state = WALKING_LEFT;
            end else begin
                next_state = WALKING_LEFT;
            end
        end

        WALKING_RIGHT: begin
            walk_right = 1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                direction <= 0;
                next_state = WALKING_LEFT;
            end else if (bump_right) begin
                direction <= 1;
                next_state = WALKING_RIGHT;
            end else begin
                next_state = WALKING_RIGHT;
            end
        end

        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (direction == 0) begin
                        next_state = WALKING_LEFT;
                    end else begin
                        next_state = WALKING_RIGHT;
                    end
                end
            end else begin
                fall_counter <= fall_counter + 1;
                next_state = FALLING;
            end
        end

        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end

        SPLATTERED: begin
            next_state = SPLATTERED;
        end

        default: begin
            next_state = WALKING_LEFT;
        end
    endcase
end

endmodule