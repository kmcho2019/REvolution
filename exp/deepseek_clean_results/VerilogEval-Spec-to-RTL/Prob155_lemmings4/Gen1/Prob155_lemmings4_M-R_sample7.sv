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

    // Define states
    localparam [2:0]
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL       = 3'b010,
        DIG        = 3'b011,
        SPLAT      = 3'b100;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg walking_left;  // Track walking direction during falls/digs

    // State transition and fall counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
            walking_left <= 1;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                if (ground) begin
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end else begin
                fall_counter <= 0;
            end
            
            // Track walking direction
            if (state == WALK_LEFT) walking_left <= 1;
            if (state == WALK_RIGHT) walking_left <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = walking_left ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule