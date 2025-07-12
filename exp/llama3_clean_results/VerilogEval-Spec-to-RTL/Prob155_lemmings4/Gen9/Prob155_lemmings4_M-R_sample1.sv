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
    DIGGING = 2'b10,
    SPLATTERED = 2'b11
} state, next_state;

// Define the walking direction
reg walking_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Update the state and fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_direction <= 1'b0; // walking left
        fall_counter <= 5'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    walking_direction <= walking_direction;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= DIGGING;
                    walking_direction <= walking_direction;
                    fall_counter <= 5'b0;
                end else if (bump_left || bump_right) begin
                    state <= WALKING;
                    walking_direction <= ~walking_direction;
                    fall_counter <= 5'b0;
                end else begin
                    state <= WALKING;
                    walking_direction <= walking_direction;
                    fall_counter <= 5'b0;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                        walking_direction <= walking_direction;
                        fall_counter <= 5'b0;
                    end else begin
                        state <= WALKING;
                        walking_direction <= walking_direction;
                        fall_counter <= 5'b0;
                    end
                end else begin
                    state <= FALLING;
                    walking_direction <= walking_direction;
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    walking_direction <= walking_direction;
                    fall_counter <= 5'b1;
                end else if (!dig) begin
                    state <= WALKING;
                    walking_direction <= walking_direction;
                    fall_counter <= 5'b0;
                end else begin
                    state <= DIGGING;
                    walking_direction <= walking_direction;
                    fall_counter <= 5'b0;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
                walking_direction <= walking_direction;
                fall_counter <= 5'b0;
            end
        endcase
    end
end

// Assign the outputs
assign walk_left = (state == WALKING &&!walking_direction) || (state == DIGGING &&!walking_direction);
assign walk_right = (state == WALKING && walking_direction) || (state == DIGGING && walking_direction);
assign aaah = state == FALLING;
assign digging = state == DIGGING;

endmodule