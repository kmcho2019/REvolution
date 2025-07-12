module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

enum logic [2:0] {
    walking_left,
    walking_right,
    falling,
    digging_state,
    splattered
} state, next_state;

logic [4:0] fall_counter;
logic original_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
        fall_counter <= 0;
        original_direction <= 1'b1;
    end else begin
        state <= next_state;
        if (next_state == falling) begin
            fall_counter <= 1;
        end else if (next_state == walking_left || next_state == walking_right) begin
            fall_counter <= 0;
        end else if (state == falling && next_state == falling) begin
            fall_counter <= fall_counter + 1;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        walking_left: begin
            if (!ground) begin
                next_state = falling;
                original_direction = 1'b1;
            end else if (dig && ground) begin
                next_state = digging_state;
                original_direction = 1'b1;
            end else if (bump_right) begin
                next_state = walking_right;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state = falling;
                original_direction = 1'b0;
            end else if (dig && ground) begin
                next_state = digging_state;
                original_direction = 1'b0;
            end else if (bump_left) begin
                next_state = walking_left;
            end
        end
        falling: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = splattered;
                end else if (original_direction) begin
                    next_state = walking_left;
                end else begin
                    next_state = walking_right;
                end
            end
        end
        digging_state: begin
            if (!ground) begin
                next_state = falling;
            end
        end
        splattered: begin
            // Do nothing
        end
    endcase
end

always_comb begin
    walk_left = (state == walking_left) || (state == digging_state && original_direction);
    walk_right = (state == walking_right) || (state == digging_state && ~original_direction);
    aaah = state == falling;
    digging = state == digging_state;
end

endmodule