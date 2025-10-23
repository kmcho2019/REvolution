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

// Define the states of the state machine
enum logic [2:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Variable to keep track of the Lemming's direction before it started falling or digging
reg walking_left;

// Counter to track the number of clock cycles the Lemming has been falling
reg [5:0] fall_counter;

always @(*) begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                walking_left = 1'b1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                walking_left = 1'b0;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
        end

        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (walking_left) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                fall_counter = fall_counter + 1;
            end
        end

        DIGGING: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = FALLING;
                walking_left = walking_left;
            end
        end

        SPLATTERED: begin
            next_state = SPLATTERED;
        end

    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

endmodule