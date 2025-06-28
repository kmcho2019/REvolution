module LemmingFSM (
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
    
    parameter WALK_LEFT = 2'b00, WALK_RIGHT = 2'b01, FALL = 2'b10, DIG = 2'b11;
    
    reg [1:0] state, next_state;
    reg [4:0] fall_duration;
    
    // Outputs
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
    // State transition logic
    always @ (posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_duration <= 0;
        end else begin
            state <= next_state;
            fall_duration <= (state == FALL) ? fall_duration + 1 : 0;
        end
    end

    // Next state logic
    always @ (*) begin
        case(state)
            WALK_LEFT: begin
                if (bump_right) next_state = WALK_RIGHT;
                else if (ground && dig) next_state = DIG;
                else if (!ground) next_state = FALL;
                else next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                if (bump_left) next_state = WALK_LEFT;
                else if (ground && dig) next_state = DIG;
                else if (!ground) next_state = FALL;
                else next_state = WALK_RIGHT;
            end
            
            FALL: begin
                if (ground && fall_duration < 20) next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                else next_state = WALK_LEFT; // Lemming splatters
            end
            
            DIG: begin
                if (!ground || ((fall_duration > 0) && ground)) next_state = FALL;
                else next_state = DIG;
            end
        endcase
    end
endmodule