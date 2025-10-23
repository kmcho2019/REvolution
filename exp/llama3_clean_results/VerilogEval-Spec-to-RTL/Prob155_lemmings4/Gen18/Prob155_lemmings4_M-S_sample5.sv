module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

reg [4:0] fall_counter;
reg walking_direction;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= WALKING;
        fall_counter <= 5'b0;
        walking_direction <= 1'b1; // walking left
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    next_state <= FALLING;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                    next_state <= WALKING;
                end else begin
                    next_state <= WALKING;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state <= SPLATTERED;
                    end else begin
                        next_state <= WALKING;
                    end
                    fall_counter <= 5'b0;
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    next_state <= FALLING;
                end else begin
                    next_state <= DIGGING;
                end
            end
            SPLATTERED: begin
                next_state <= SPLATTERED;
            end
        endcase
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        WALKING: begin
            walk_left = walking_direction;
            walk_right = ~walking_direction;
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
            walk_left = walking_direction;
            walk_right = ~walking_direction;
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