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

reg [2:0] state; // 3 bits for 5 states (WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, DEAD)
reg [5:0] fall_counter; // Counter for fall duration
reg walk_direction; // 0 for left, 1 for right

// State encoding
localparam WALK_LEFT = 3'b000;
localparam WALK_RIGHT = 3'b001;
localparam FALLING = 3'b010;
localparam DIGGING = 3'b011;
localparam DEAD = 3'b100;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'b0;
        walk_direction <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    walk_direction <= 1;
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    walk_direction <= 0;
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right) begin
                    walk_direction <= 0;
                    state <= WALK_LEFT;
                end else if (bump_left) begin
                    walk_direction <= 1;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= DEAD;
                    end else begin
                        state <= walk_direction ? WALK_RIGHT : WALK_LEFT;
                    end
                    fall_counter <= 6'b0;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (~dig) begin
                    state <= walk_direction ? WALK_RIGHT : WALK_LEFT;
                end
            end
            DEAD: begin
                // Do nothing, stay in DEAD state
            end
        endcase
    end
end

always @(state or walk_direction) begin
    case (state)
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
        DEAD: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule