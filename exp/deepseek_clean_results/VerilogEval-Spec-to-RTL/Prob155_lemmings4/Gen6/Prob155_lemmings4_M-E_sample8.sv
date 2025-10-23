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
    
    // Action states
    typedef enum logic [1:0] {
        ACT_WALK,
        ACT_FALL,
        ACT_DIG,
        ACT_SPLAT
    } act_state_t;
    
    // State registers
    dir_state_t dir_state, next_dir;
    act_state_t act_state, next_act;
    
    // Saved direction for returning from fall/dig
    reg saved_dir;
    reg [4:0] fall_timer;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir_state <= DIR_LEFT;
            act_state <= ACT_WALK;
            saved_dir <= 1'b0; // Left
            fall_timer <= 0;
        end else begin
            dir_state <= next_dir;
            act_state <= next_act;
            
            // Update saved direction when walking
            if (act_state == ACT_WALK) begin
                saved_dir <= dir_state;
            end
            
            // Update fall timer
            if (act_state == ACT_FALL) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Direction FSM
    always @(*) begin
        next_dir = dir_state;
        
        if (act_state == ACT_WALK) begin
            case ({bump_left, bump_right})
                2'b10: next_dir = DIR_RIGHT;
                2'b01: next_dir = DIR_LEFT;
                default: next_dir = dir_state;
            endcase
        end
    end

    // Action FSM
    always @(*) begin
        next_act = act_state;
        
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
                    next_dir = saved_dir;
                    saved_dir = saved_dir; // Maintain direction
                    fall_timer = 0;
                    // Note: This maintains direction from before fall
                end
                else begin
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

    // Output logic
    assign walk_left = (act_state == ACT_WALK) && (dir_state == DIR_LEFT) && (act_state != ACT_SPLAT);
    assign walk_right = (act_state == ACT_WALK) && (dir_state == DIR_RIGHT) && (act_state != ACT_SPLAT);
    assign aaah = (act_state == ACT_FALL);
    assign digging = (act_state == ACT_DIG);

endmodule