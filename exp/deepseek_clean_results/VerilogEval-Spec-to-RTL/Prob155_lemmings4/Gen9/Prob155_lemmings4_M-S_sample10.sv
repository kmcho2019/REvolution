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

    // States
    parameter WALK = 2'd0;
    parameter DIG  = 2'd1;
    parameter FALL = 2'd2;
    parameter SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg [4:0] fall_counter;
    reg walking_left;  // Current walking direction

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            fall_counter <= 0;
            walking_left <= 1;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                fall_counter <= ground ? 0 : fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
            
            // Update direction when walking
            if (state == WALK) begin
                if (bump_left) walking_left <= 0;
                if (bump_right) walking_left <= 1;
            end
        end
    end

    // Next state logic with priority
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else next_state = WALK;
            end
            
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : 
                                (walking_left ? WALK : WALK);
                end else begin
                    next_state = FALL;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) && walking_left;
    assign walk_right = (state == WALK) && !walking_left;
    assign aaah = (state == FALL) || (state == SPLAT && fall_counter > 20);
    assign digging = (state == DIG);

endmodule