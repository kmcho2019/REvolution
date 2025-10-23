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
    typedef enum {DIR_LEFT, DIR_RIGHT} dir_state_t;
    dir_state_t dir_state, next_dir;

    // Action states
    typedef enum {ACT_WALK, ACT_FALL, ACT_DIG, ACT_SPLAT} act_state_t;
    act_state_t act_state, next_act;

    reg [4:0] fall_cycles;
    reg walking_left, walking_right;

    // Direction FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir_state <= DIR_LEFT;
        end else begin
            dir_state <= next_dir;
        end
    end

    // Action FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            act_state <= ACT_WALK;
            fall_cycles <= 0;
        end else begin
            act_state <= next_act;
            
            // Update fall timer
            if (act_state == ACT_FALL) begin
                fall_cycles <= fall_cycles + 1;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Next direction logic (only changes when walking)
    always @(*) begin
        next_dir = dir_state;
        if (act_state == ACT_WALK) begin
            case (dir_state)
                DIR_LEFT: if (bump_left) next_dir = DIR_RIGHT;
                DIR_RIGHT: if (bump_right) next_dir = DIR_LEFT;
            endcase
        end
    end

    // Next action logic (implements priority)
    always @(*) begin
        next_act = act_state;
        
        case (act_state)
            ACT_WALK: begin
                if (~ground) begin
                    next_act = ACT_FALL;
                end else if (dig) begin
                    next_act = ACT_DIG;
                end
            end
            
            ACT_FALL: begin
                if (ground) begin
                    if (fall_cycles > 20) begin
                        next_act = ACT_SPLAT;
                    end else begin
                        next_act = ACT_WALK;
                    end
                end
            end
            
            ACT_DIG: begin
                if (~ground) begin
                    next_act = ACT_FALL;
                end
            end
            
            ACT_SPLAT: begin
                next_act = ACT_SPLAT; // Permanent state
            end
        endcase
    end

    // Output logic
    assign walking_left = (dir_state == DIR_LEFT) && (act_state == ACT_WALK);
    assign walking_right = (dir_state == DIR_RIGHT) && (act_state == ACT_WALK);
    
    assign walk_left = walking_left && ~digging && ~aaah;
    assign walk_right = walking_right && ~digging && ~aaah;
    assign aaah = (act_state == ACT_FALL);
    assign digging = (act_state == ACT_DIG);

endmodule