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

enum logic [1:0] {WALKING, FALLING, DIGGING, SPLATTERED} state, next_state;
reg [4:0] fall_counter;
reg walking_direction;

always @(posedge areset) begin
    state <= WALKING;
    fall_counter <= 5'b0;
    walking_direction <= 1'b1; // walking left
end

always_ff @(posedge clk) begin
    if (state == WALKING) begin
        if (!ground) begin
            next_state <= FALLING;
        end else if (dig) begin
            next_state <= DIGGING;
        end else if (bump_left || bump_right) begin
            walking_direction <= ~walking_direction;
        end
    end else if (state == FALLING) begin
        fall_counter <= fall_counter + 1'b1;
        if (ground) begin
            if (fall_counter > 5'd20) begin
                next_state <= SPLATTERED;
            end else begin
                next_state <= WALKING;
            end
            fall_counter <= 5'b0;
        end
    end else if (state == DIGGING) begin
        if (!ground) begin
            next_state <= FALLING;
        end
    end else if (state == SPLATTERED) begin
        // do nothing
    end
    state <= next_state;
end

always_comb begin
    walk_left = (state == WALKING && walking_direction) || (state == DIGGING && walking_direction);
    walk_right = (state == WALKING && ~walking_direction) || (state == DIGGING && ~walking_direction);
    aaah = state == FALLING;
    digging = state == DIGGING;
end

endmodule