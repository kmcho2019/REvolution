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

    // Direction states (independent of action)
    typedef enum logic {
        DIR_LEFT,
        DIR_RIGHT
    } dir_state_t;
    
    // Action states (what the lemming is doing)
    typedef enum logic [1:0] {
        ACT_WALK,
        ACT_FALL,
        ACT_DIG,
        ACT_SPLAT
    } act_state_t;
    
    dir_state_t dir_state, next_dir;
    act_state_t act_state, next_act;
    
    reg [4:0] fall_timer;
    reg saved_dir; // 0=left, 1=right
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir_state <= DIR_LEFT;
            act_state <= ACT_WALK;
            fall_timer <= 0;
            saved_dir <= 0;
        end else begin
            dir_state <= next_dir;
            act_state <= next_act;
            
            // Update fall timer
            if (act_state == ACT_FALL) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
            
            // Save direction when starting to fall/dig
            if ((act_state == ACT_WALK) && 
                ((next_act == ACT_FALL) || (next_act == ACT_DIG))) begin
                saved_dir <= (dir_state == DIR_RIGHT);
            end
        end
    end

    // Action state transition logic (priority: fall > dig > walk)
    always @(*) begin
        case (act_state)
            ACT_WALK: begin
                if (~ground) begin
                    next_act = ACT_FALL;
                end else if (dig) begin
                    next_act = ACT_DIG;
                end else begin
                    next_act = ACT_WALK;
                end
            end
            
            ACT_FALL: begin
                if (ground) begin
                    if (fall_timer > 20) begin
                        next_act = ACT_SPLAT;
                    end else begin
                        next_act = ACT_WALK;
                    end
                end else begin
                    next_act = ACT_FALL;
                end
            end
            
            ACT_DIG: begin
                if (~ground) begin
                    next_act = ACT_FALL;
                end else begin
                    next_act = ACT_DIG;
                end
            end
            
            ACT_SPLAT: begin
                next_act = ACT_SPLAT;
            end
            
            default: next_act = ACT_WALK;
        endcase
    end

    // Direction state transition logic
    always @(*) begin
        if (act_state != ACT_WALK) begin
            next_dir = dir_state; // Maintain direction when not walking
        end else begin
            case (dir_state)
                DIR_LEFT: next_dir = bump_left ? DIR_RIGHT : DIR_LEFT;
                DIR_RIGHT: next_dir = bump_right ? DIR_LEFT : DIR_RIGHT;
                default: next_dir = DIR_LEFT;
            endcase
        end
    end

    // Output logic - simplified to avoid type conflicts
    assign walk_left = (act_state == ACT_WALK) && (dir_state == DIR_LEFT);
    assign walk_right = (act_state == ACT_WALK) && (dir_state == DIR_RIGHT);
    assign aaah = (act_state == ACT_FALL);
    assign digging = (act_state == ACT_DIG);

endmodule