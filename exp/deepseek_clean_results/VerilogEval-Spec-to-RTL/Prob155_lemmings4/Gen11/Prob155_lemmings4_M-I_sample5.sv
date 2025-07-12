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

    // State encoding (one-hot for better timing)
    localparam WALK_LEFT  = 4'b0001;
    localparam WALK_RIGHT = 4'b0010;
    localparam FALL       = 4'b0100;
    localparam DIG        = 4'b1000;
    // Splatter is implicit (all outputs zero)

    reg [3:0] state, next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_timer;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    // Handle direction changes
                    if (bump_left && !bump_right) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right && !bump_left) begin
                        next_state = WALK_LEFT;
                    end else if (bump_left && bump_right) begin
                        next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end else begin
                        next_state = state;
                    end
                end
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_timer > 20) begin
                        next_state = 4'b0000; // Splatter
                    end else begin
                        next_state = direction ? WALK_RIGHT : WALK_LEFT;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
            
            default: next_state = WALK_LEFT; // Default to walk left
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 0;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update direction register
            if (state == WALK_LEFT) direction <= 0;
            else if (state == WALK_RIGHT) direction <= 1;
            
            // Update fall timer
            if (state == FALL && !ground) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule