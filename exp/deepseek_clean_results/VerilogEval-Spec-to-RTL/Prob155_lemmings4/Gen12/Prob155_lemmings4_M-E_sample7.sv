module TopModule (
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

    // Main states
    localparam [1:0] 
        WALKING = 2'b00,
        FALLING = 2'b01,
        DIGGING = 2'b10,
        SPLATTERED = 2'b11;

    // Direction tracking
    localparam LEFT = 1'b0, RIGHT = 1'b1;

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // Next state logic
    always @(*) begin
        case (current_state)
            WALKING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALKING;
                    // Handle direction changes
                    if (bump_left && !bump_right) direction = RIGHT;
                    if (bump_right && !bump_left) direction = LEFT;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALKING;
                end else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                if (!ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            
            SPLATTERED: begin
                next_state = SPLATTERED;
            end
            
            default: next_state = WALKING;
        endcase
    end

    // State transition and counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING;
            direction <= LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            
            // Update fall counter
            if (current_state == FALLING) begin
                if (!ground)
                    fall_counter <= fall_counter + 1;
                else
                    fall_counter <= 0;
            end else begin
                fall_counter <= 0;
            end
            
            // Preserve direction during special states
            if (current_state == WALKING && next_state == WALKING) begin
                // Only update direction when actively walking
                if (bump_left && !bump_right) direction <= RIGHT;
                if (bump_right && !bump_left) direction <= LEFT;
            end
        end
    end

    // Output logic
    assign walk_left = (current_state == WALKING) && !direction && !digging;
    assign walk_right = (current_state == WALKING) && direction && !digging;
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule