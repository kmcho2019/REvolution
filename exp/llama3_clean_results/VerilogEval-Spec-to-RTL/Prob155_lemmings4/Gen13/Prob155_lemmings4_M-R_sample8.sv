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
    DIGGING = 2'b10
} state, next_state;

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
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else if (dig && ground) begin
                    next_state <= DIGGING;
                end else if (bump_left) begin
                    walking_left_direction <= 1'b0;
                    next_state <= WALKING;
                end else if (bump_right) begin
                    walking_left_direction <= 1'b1;
                    next_state <= WALKING;
                end else begin
                    next_state <= WALKING;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        is_splattered <= 1'b1;
                    end
                    next_state <= WALKING;
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (!dig || !ground) begin
                    next_state <= WALKING;
                end else if (!ground) begin
                    next_state <= FALLING;
                end else begin
                    next_state <= DIGGING;
                end
            end
        endcase
        state <= next_state;
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
        endcase
    end
end

endmodule