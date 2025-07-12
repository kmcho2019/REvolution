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

// Define the top-level states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10
} top_state;

// Define the walking direction states
enum logic {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_dir;

// Define the fall counter
reg [4:0] fall_counter;

// Define the is_splattered signal
reg is_splattered;

// Update the top-level state and walk direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= WALKING;
        walk_dir <= LEFT;
        fall_counter <= 5'b0;
        is_splattered <= 1'b0;
    end else if (~is_splattered) begin
        case (top_state)
            WALKING: begin
                if (~ground) begin
                    top_state <= FALLING;
                end else if (dig) begin
                    top_state <= DIGGING;
                end else if (bump_left && walk_dir == LEFT) begin
                    walk_dir <= RIGHT;
                end else if (bump_right && walk_dir == RIGHT) begin
                    walk_dir <= LEFT;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        is_splattered <= 1'b1;
                    end
                    top_state <= WALKING;
                    fall_counter <= 5'b0;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    top_state <= FALLING;
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
        case (top_state)
            WALKING: begin
                if (walk_dir == LEFT) begin
                    walk_left = 1'b1;
                    walk_right = 1'b0;
                end else begin
                    walk_left = 1'b0;
                    walk_right = 1'b1;
                end
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