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

// Define the states
enum logic [3:0] {
    WALK_LEFT = 4'd0,
    WALK_RIGHT = 4'd1,
    FALLING = 4'd2,
    DIGGING = 4'd3,
    SPLATTERED = 4'd4
} state, next_state;

// Define the direction of the Lemming
reg walk_dir;

// Define the counter for the number of clock cycles spent falling
reg [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_dir <= 1'b0;
        fall_counter <= 6'd0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || (bump_right && ~bump_left)) begin
                    state <= WALK_RIGHT;
                    walk_dir <= 1'b1;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                    walk_dir <= 1'b0;
                end else begin
                    state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right || (bump_left && ~bump_right)) begin
                    state <= WALK_LEFT;
                    walk_dir <= 1'b0;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                    walk_dir <= 1'b1;
                end else begin
                    state <= WALK_RIGHT;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= (walk_dir) ? WALK_RIGHT : WALK_LEFT;
                        fall_counter <= 6'd0;
                    end
                end else begin
                    state <= FALLING;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 6'd0;
                end else begin
                    state <= DIGGING;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
        endcase
    end
end

always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule