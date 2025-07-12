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
enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Define the direction
reg dir;

// Define the falling counter
reg [5:0] falling_counter;

// Initialize the state and direction
initial begin
    state = IDLE_LEFT;
    dir = 1'b1; // walk left by default
    walk_left = 1'b1;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
end

// State machine logic
always @(*) begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1'b1;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
                dir = 1'b0;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
                dir = 1'b1;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1'b1;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
                dir = 1'b1;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
                dir = 1'b0;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (falling_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = dir ? IDLE_LEFT : IDLE_RIGHT;
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase
end

// Update the state and counter on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        dir <= 1'b1;
        falling_counter <= 6'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            falling_counter <= falling_counter + 1;
        end else begin
            falling_counter <= 6'b0;
        end
    end
end
endmodule