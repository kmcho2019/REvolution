module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states of the state machine
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING
} state, next_state;

// Define the direction of the Lemming
logic [1:0] direction, next_direction;

// Initialize the state and direction
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= 1'b0; // Walking left
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Determine the next state and direction
always_comb begin
    next_state = state;
    next_direction = direction;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left &&!bump_right) begin
                next_direction = 1'b1; // Walking right
            end else if (!bump_left && bump_right) begin
                next_direction = 1'b0; // Walking left
            end
            if (direction == 1'b0) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
            aaah = 1'b1;
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
            digging = 1'b1;
            if (direction == 1'b0) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end
        end
    endcase
end

endmodule