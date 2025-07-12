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

    // Direction FSM states
    typedef enum logic { LEFT, RIGHT } dir_state_t;
    dir_state_t dir_state, next_dir;

    // Action FSM states
    typedef enum logic [2:0] {
        WALKING,
        FALLING,
        DIGGING,
        SPLATTERED
    } action_state_t;
    
    action_state_t action_state, next_action;
    reg [4:0] fall_cycles;

    // Direction FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir_state <= LEFT;
        end else if (action_state == WALKING) begin
            dir_state <= next_dir;
        end
    end

    always @(*) begin
        next_dir = dir_state;
        if (bump_left && !bump_right) begin
            next_dir = RIGHT;
        end else if (bump_right && !bump_left) begin
            next_dir = LEFT;
        end else if (bump_left && bump_right) begin
            next_dir = ~dir_state;
        end
    end

    // Action FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action_state <= WALKING;
            fall_cycles <= 0;
        end else begin
            action_state <= next_action;
            
            // Fall duration counter
            if (action_state == FALLING) begin
                fall_cycles <= (!ground) ? fall_cycles + 1 : 0;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    always @(*) begin
        case (action_state)
            WALKING: begin
                if (!ground) begin
                    next_action = FALLING;
                end else if (dig) begin
                    next_action = DIGGING;
                end else begin
                    next_action = WALKING;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    next_action = (fall_cycles > 20) ? SPLATTERED : WALKING;
                end else begin
                    next_action = FALLING;
                end
            end
            
            DIGGING: begin
                next_action = (!ground) ? FALLING : DIGGING;
            end
            
            SPLATTERED: begin
                next_action = SPLATTERED;
            end
            
            default: next_action = WALKING;
        endcase
    end

    // Output logic
    assign walk_left = (action_state == WALKING) && (dir_state == LEFT) && (action_state != SPLATTERED);
    assign walk_right = (action_state == WALKING) && (dir_state == RIGHT) && (action_state != SPLATTERED);
    assign aaah = (action_state == FALLING);
    assign digging = (action_state == DIGGING);

endmodule