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

// Define the states
parameter WALK_LEFT = 4'b0000;
parameter WALK_RIGHT = 4'b0001;
parameter FALLING = 4'b0010;
parameter DIGGING = 4'b0011;
parameter SPLATTERED = 4'b0100;

// Define the state register
reg [3:0] state;
reg [3:0] next_state;

// Define the direction register
reg walk_direction;

// Define the fall counter
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Output logic
always @(*)
begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    if (state == WALK_LEFT) begin
        walk_left = 1;
    end else if (state == WALK_RIGHT) begin
        walk_right = 1;
    end else if (state == FALLING) begin
        aaah = 1;
    end else if (state == DIGGING) begin
        digging = 1;
    end
end

// Next state logic
always @(*)
begin
    next_state = state;
    next_fall_counter = fall_counter;
    if (areset) begin
        next_state = WALK_LEFT;
        next_fall_counter = 0;
        walk_direction = 0;
    end else begin
        if (state == WALK_LEFT) begin
            if (!ground) begin
                next_state = FALLING;
                walk_direction = 0;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
                walk_direction = 1;
            end
        end else if (state == WALK_RIGHT) begin
            if (!ground) begin
                next_state = FALLING;
                walk_direction = 1;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                walk_direction = 0;
            end
        end else if (state == FALLING) begin
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (walk_direction) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
                next_fall_counter = 0;
            end
        end else if (state == DIGGING) begin
            if (!ground) begin
                next_state = FALLING;
                walk_direction = walk_direction;
                next_fall_counter = 0;
            end
        end else if (state == SPLATTERED) begin
            // Do nothing
        end
    end
end

// State register update
always @(posedge clk)
begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

endmodule