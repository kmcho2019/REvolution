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

    // Direction states
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    reg direction, next_direction;

    // Action states
    localparam [1:0]
        WALK  = 2'b00,
        FALL  = 2'b01,
        DIG   = 2'b10,
        SPLAT = 2'b11;
    reg [1:0] action, next_action;

    // Fall timer
    reg [4:0] fall_timer;
    wire splat_condition = (fall_timer > 20) && ground;

    // Priority encoder signals
    wire should_fall = ~ground;
    wire should_dig = (action == WALK) && dig && ground;
    wire should_change_dir = (action == WALK) && ground && 
                            (bump_left || bump_right);

    // Direction state machine
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= LEFT;
        end else begin
            direction <= next_direction;
        end
    end

    always @(*) begin
        next_direction = direction; // default: keep direction
        
        if (action == WALK && ground) begin
            if (bump_left && !bump_right) begin
                next_direction = RIGHT;
            end else if (bump_right && !bump_left) begin
                next_direction = LEFT;
            end
        end
    end

    // Action state machine
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action <= WALK;
            fall_timer <= 0;
        end else begin
            action <= next_action;
            
            // Update fall timer
            if (action == FALL) begin
                fall_timer <= ground ? 0 : fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Action state transitions
    always @(*) begin
        case (action)
            WALK: begin
                if (should_fall) begin
                    next_action = FALL;
                end else if (should_dig) begin
                    next_action = DIG;
                end else begin
                    next_action = WALK;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_action = splat_condition ? SPLAT : WALK;
                end else begin
                    next_action = FALL;
                end
            end
            
            DIG: begin
                if (should_fall) begin
                    next_action = FALL;
                end else begin
                    next_action = DIG;
                end
            end
            
            SPLAT: begin
                next_action = SPLAT;
            end
            
            default: next_action = WALK;
        endcase
    end

    // Output logic
    assign walk_left = (action == WALK) && (direction == LEFT);
    assign walk_right = (action == WALK) && (direction == RIGHT);
    assign aaah = (action == FALL);
    assign digging = (action == DIG);

endmodule