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

// Define the states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    SPLATTERED = 2'b10
} state, next_state;

// Define the walking direction
reg walking_left_direction;

// Define the fall counter
reg [4:0] fall_counter;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left_direction <= 1'b1;
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        if (next_state == WALKING) begin
            walking_left_direction <= walking_left_direction;
        end else if (next_state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else if (next_state == SPLATTERED) begin
            walking_left_direction <= 1'b0;
            fall_counter <= 5'b0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                // Continue walking and start digging
            end else if (bump_left ^ bump_right) begin
                walking_left_direction = ~walking_left_direction;
            end else if (bump_left && bump_right) begin
                walking_left_direction = ~walking_left_direction;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
                fall_counter = 5'b0;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        WALKING: begin
            walk_left = walking_left_direction;
            walk_right = ~walking_left_direction;
            aaah = 1'b0;
            digging = dig;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
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