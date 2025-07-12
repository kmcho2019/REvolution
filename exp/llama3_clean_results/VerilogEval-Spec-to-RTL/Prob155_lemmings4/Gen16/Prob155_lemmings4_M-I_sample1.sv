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
    FALLING = 2'b01
} state;

// Define the walking direction
reg walking_left_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Define the is_splattered signal
reg is_splattered;

// Update the state and fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left_direction <= 1'b1;
        fall_counter <= 5'b0;
        is_splattered <= 1'b0;
    end else if (~is_splattered) begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig && ground) begin
                    // Continue walking in the same direction while digging
                end else if (bump_left) begin
                    walking_left_direction <= 1'b0;
                end else if (bump_right) begin
                    walking_left_direction <= 1'b1;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        is_splattered <= 1'b1;
                    end
                    state <= WALKING;
                    fall_counter <= 5'b0;
                end
            end
        endcase
    end
end

// Assign the outputs
always @(*) begin
    if (is_splattered) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end else begin
        case (state)
            WALKING: begin
                walk_left = walking_left_direction;
                walk_right = ~walking_left_direction;
                aaah = 1'b0;
                digging = dig && ground;
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
        endcase
    end
end

endmodule