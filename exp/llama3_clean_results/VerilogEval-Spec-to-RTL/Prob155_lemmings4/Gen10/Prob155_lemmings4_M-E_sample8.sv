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
enum logic [2:0] {
    WALKING_LEFT = 3'b000,
    WALKING_RIGHT = 3'b001,
    FALLING = 3'b010,
    DIGGING = 3'b011,
    SPLATTERED = 3'b100
} state, next_state;

// Define the walking direction
reg walking_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        walking_direction <= 1'b0;
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        WALKING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_RIGHT;
            end else begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_LEFT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (!dig) begin
                next_state = WALKING_LEFT;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Assign the outputs
assign walk_left = (state == WALKING_LEFT);
assign walk_right = (state == WALKING_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule