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
    typedef enum logic {
        DIR_LEFT,
        DIR_RIGHT
    } dir_state_t;
    
    dir_state_t dir_state, next_dir_state;
    reg saved_dir; // 0=left, 1=right

    // Action states
    typedef enum logic [1:0] {
        ACT_WALK,
        ACT_FALL,
        ACT_DIG,
        ACT_SPLAT
    } act_state_t;
    
    act_state_t act_state, next_act_state;
    reg [4:0] fall_timer;

    // Direction FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir_state <= dir_state_t'(DIR_LEFT);
        end else if (act_state == ACT_WALK) begin
            dir_state <= next_dir_state;
        end
    end

    always @(*) begin
        case (dir_state)
            DIR_LEFT: next_dir_state = bump_left ? dir_state_t'(DIR_RIGHT) : dir_state_t'(DIR_LEFT);
            DIR_RIGHT: next_dir_state = bump_right ? dir_state_t'(DIR_LEFT) : dir_state_t'(DIR_RIGHT);
            default: next_dir_state = dir_state_t'(DIR_LEFT);
        endcase
    end

    // Action FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            act_state <= act_state_t'(ACT_WALK);
            fall_timer <= 0;
            saved_dir <= 0;
        end else begin
            act_state <= next_act_state;
            
            // Update fall timer
            if (act_state == ACT_FALL) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
            
            // Save direction when starting to fall/dig
            if ((act_state == ACT_WALK && next_act_state == ACT_FALL) ||
                (act_state == ACT_WALK && next_act_state == ACT_DIG)) begin
                saved_dir <= (dir_state == DIR_RIGHT);
            end
        end
    end

    always @(*) begin
        case (act_state)
            ACT_WALK: begin
                if (~ground) begin
                    next_act_state = act_state_t'(ACT_FALL);
                end else if (dig) begin
                    next_act_state = act_state_t'(ACT_DIG);
                end else begin
                    next_act_state = act_state_t'(ACT_WALK);
                end
            end
            
            ACT_FALL: begin
                if (ground) begin
                    next_act_state = (fall_timer > 20) ? act_state_t'(ACT_SPLAT) : act_state_t'(ACT_WALK);
                end else begin
                    next_act_state = act_state_t'(ACT_FALL);
                end
            end
            
            ACT_DIG: begin
                if (~ground) begin
                    next_act_state = act_state_t'(ACT_FALL);
                end else begin
                    next_act_state = act_state_t'(ACT_DIG);
                end
            end
            
            ACT_SPLAT: begin
                next_act_state = act_state_t'(ACT_SPLAT);
            end
            
            default: next_act_state = act_state_t'(ACT_WALK);
        endcase
    end

    // Output logic
    assign walk_left = (act_state == ACT_WALK) && (dir_state == DIR_LEFT);
    assign walk_right = (act_state == ACT_WALK) && (dir_state == DIR_RIGHT);
    assign aaah = (act_state == ACT_FALL);
    assign digging = (act_state == ACT_DIG);

endmodule