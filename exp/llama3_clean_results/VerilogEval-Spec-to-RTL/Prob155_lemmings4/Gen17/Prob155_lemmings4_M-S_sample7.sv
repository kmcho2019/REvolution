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
reg walk_direction;

// Define the fall counter
reg [5:0] fall_counter;

// Define the is_splattered signal
reg is_splattered;

// Update the state and fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 1'b0;
        fall_counter <= 6'b0;
        is_splattered <= 1'b0;
    end else if (~is_splattered) begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    // start digging
                    digging <= 1'b1;
                end else if (bump_left && ~walk_direction) begin
                    walk_direction <= 1'b1;
                end else if (bump_right && walk_direction) begin
                    walk_direction <= 1'b0;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 6'd20) begin
                        is_splattered <= 1'b1;
                    end
                    state <= WALKING;
                    fall_counter <= 6'b0;
                    digging <= 1'b0;
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
                if (walk_direction) begin
                    walk_left = 1'b0;
                    walk_right = 1'b1;
                end else begin
                    walk_left = 1'b1;
                    walk_right = 1'b0;
                end
                aaah = 1'b0;
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        endcase
    end
end

endmodule