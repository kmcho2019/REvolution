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
    WALKING_LEFT = 2'b00,
    WALKING_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state;

// Define the fall counter
reg [4:0] fall_counter;

// Define the is_splattered signal
reg is_splattered;

// Update the state and fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        fall_counter <= 5'b0;
        is_splattered <= 1'b0;
    end else if (~is_splattered) begin
        case (state)
            WALKING_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                end else if (bump_right) begin
                    // do nothing
                end
            end
            WALKING_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    // do nothing
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        is_splattered <= 1'b1;
                    end
                    if (state == FALLING) begin
                        state <= WALKING_LEFT; // when falling, and then hitting the ground, the lemming walks left
                    end
                    fall_counter <= 5'b0;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
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
            WALKING_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            WALKING_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
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