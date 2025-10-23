module TopModule (
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

    // Primary states
    parameter WALKING = 2'b00;
    parameter DIGGING = 2'b01;
    parameter FALLING = 2'b10;
    parameter SPLAT   = 2'b11;

    // Direction states
    parameter LEFT  = 1'b0;
    parameter RIGHT = 1'b1;

    reg [1:0] state, next_state;
    reg direction, next_direction;
    reg [4:0] fall_counter;

    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;

        case (state)
            WALKING: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // Switch direction if bumped, priority to left if both
                    next_direction = bump_left ? RIGHT : LEFT;
                end
            end

            DIGGING: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (~dig) begin
                    next_state = WALKING;
                end
            end

            FALLING: begin
                if (ground) begin
                    next_state = (fall_counter > 5'd20) ? SPLAT : WALKING;
                end
            end

            SPLAT: begin
                next_state = SPLAT;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;

            // Fall counter logic
            if (state == FALLING) begin
                fall_counter <= ground ? 5'd0 : fall_counter + 1'b1;
            end else begin
                fall_counter <= 5'd0;
            end
        end
    end

    // Output logic
    assign walk_left  = (state == WALKING) & (direction == LEFT);
    assign walk_right = (state == WALKING) & (direction == RIGHT);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule