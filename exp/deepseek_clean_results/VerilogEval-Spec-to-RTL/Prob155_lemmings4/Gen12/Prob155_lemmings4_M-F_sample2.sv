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

    // Combined state and direction encoding
    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALL_LEFT,
        FALL_RIGHT,
        DIG_LEFT,
        DIG_RIGHT,
        SPLATTERED
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_timer;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= state_t'(WALK_LEFT);
            fall_timer <= 0;
        end else begin
            current_state <= next_state;
            
            // Update fall timer
            if ((current_state == FALL_LEFT) || (current_state == FALL_RIGHT)) begin
                fall_timer <= ground ? 0 : fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    next_state = current_state == WALK_LEFT ? state_t'(FALL_LEFT) : state_t'(FALL_RIGHT);
                end else if (dig && ground) begin
                    next_state = current_state == WALK_LEFT ? state_t'(DIG_LEFT) : state_t'(DIG_RIGHT);
                end else if ((current_state == WALK_LEFT && bump_left) || 
                           (current_state == WALK_RIGHT && bump_right)) begin
                    next_state = current_state == WALK_LEFT ? state_t'(WALK_RIGHT) : state_t'(WALK_LEFT);
                end else begin
                    next_state = current_state;
                end
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    next_state = current_state == DIG_LEFT ? state_t'(FALL_LEFT) : state_t'(FALL_RIGHT);
                end else begin
                    next_state = current_state;
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? state_t'(SPLATTERED) : 
                                 (current_state == FALL_LEFT ? state_t'(WALK_LEFT) : state_t'(WALK_RIGHT));
                end else begin
                    next_state = current_state;
                end
            end
            
            SPLATTERED: begin
                next_state = state_t'(SPLATTERED);
            end
            
            default: begin
                next_state = state_t'(WALK_LEFT);
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALL_LEFT) || (current_state == FALL_RIGHT);
    assign digging = (current_state == DIG_LEFT) || (current_state == DIG_RIGHT);

endmodule