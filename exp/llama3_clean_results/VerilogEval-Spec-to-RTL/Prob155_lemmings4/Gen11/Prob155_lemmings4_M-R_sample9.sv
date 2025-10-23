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
    WALKING = 3'b000,
    FALLING = 3'b010,
    DIGGING = 3'b011,
    SPLATTERED = 3'b100
} state, next_state;

// Define the walking direction
reg walking_left;

// Define the fall counter
reg [4:0] fall_counter;

// Define the splattered signal
reg splattered;

// Update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left <= 1'b1;
        fall_counter <= 5'b0;
        splattered <= 1'b0;
    end else begin
        state <= next_state;
        walking_left <= (state == WALKING && (bump_left || !bump_right)) || (state == FALLING && ground && fall_counter <= 5'd20 && walking_left);
        walking_left <= ~(state == WALKING && (bump_right || !bump_left)) || (state == FALLING && ground && fall_counter <= 5'd20 && ~walking_left);
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
        splattered <= splattered || (state == FALLING && ground && fall_counter > 5'd20);
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                next_state = WALKING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (!dig) begin
                next_state = WALKING;
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
assign walk_left = (state == WALKING && walking_left) && !splattered;
assign walk_right = (state == WALKING && ~walking_left) && !splattered;
assign aaah = (state == FALLING) && !splattered;
assign digging = (state == DIGGING) && !splattered;

endmodule