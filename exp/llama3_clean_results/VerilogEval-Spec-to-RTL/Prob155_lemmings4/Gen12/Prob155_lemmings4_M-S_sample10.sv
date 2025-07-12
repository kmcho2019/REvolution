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
} state;

// Define the walking direction
reg walking_left_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Define the is_splattered signal
reg is_splattered;

// Update the state
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
                    state <= FALLING;
                end else if (dig && ground) begin
                    state <= DIGGING;
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
                    end else begin
                        state <= WALKING;
                    end
                end
            end
            DIGGING: begin
                if (!dig ||!ground) begin
                    state <= WALKING;
                end else if (!ground) begin
                    state <= FALLING;
                end
            end
        endcase
    end
end

// Assign the outputs
assign walk_left = (state == WALKING && walking_left_direction) &&!is_splattered;
assign walk_right = (state == WALKING && ~walking_left_direction) &&!is_splattered;
assign aaah = (state == FALLING) &&!is_splattered;
assign digging = (state == DIGGING) &&!is_splattered;

endmodule