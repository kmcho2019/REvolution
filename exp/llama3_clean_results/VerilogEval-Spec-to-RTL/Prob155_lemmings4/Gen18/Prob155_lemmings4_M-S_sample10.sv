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
} state;

// Define the walking direction
reg walking_left_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Update the state and fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left_direction <= 1'b1;
        fall_counter <= 5'b0;
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 1'b1;
                end else if (dig) begin
                    walking_left_direction <= walking_left_direction;
                end else if (bump_left ^ bump_right) begin
                    walking_left_direction <= ~walking_left_direction;
                end else if (bump_left && bump_right) begin
                    walking_left_direction <= ~walking_left_direction;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                        fall_counter <= 5'b0;
                    end
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
        endcase
    end
end

// Assign the outputs
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