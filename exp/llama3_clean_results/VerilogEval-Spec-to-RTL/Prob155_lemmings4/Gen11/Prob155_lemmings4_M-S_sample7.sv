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
reg walking_direction;

// Define the fall counter
reg [4:0] fall_counter;
reg is_digging;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_direction <= 1'b0; // walking left
        fall_counter <= 5'b0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (dig && ground && !is_digging) begin
                    is_digging <= 1'b1;
                end else if (!dig && is_digging) begin
                    is_digging <= 1'b0;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            SPLATTERED: begin
                // Do nothing
            end
        endcase
    end
end

// Combinational logic
assign walk_left = (state == WALKING && !is_digging && !walking_direction) || (state == WALKING && is_digging && !walking_direction);
assign walk_right = (state == WALKING && !is_digging && walking_direction) || (state == WALKING && is_digging && walking_direction);
assign aaah = state == FALLING;
assign digging = is_digging && state == WALKING;

endmodule