module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // Walking FSM states
    parameter WALK_L = 1'b0;
    parameter WALK_R = 1'b1;
    reg walk_state;
    
    // Falling FSM states
    parameter ON_GROUND = 1'b0;
    parameter FALLING = 1'b1;
    reg fall_state;
    
    // Direction register to preserve during falls
    reg saved_direction;
    
    // Walking FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_state <= WALK_L;
        end else if (fall_state == ON_GROUND) begin
            case (walk_state)
                WALK_L: if (bump_left) walk_state <= WALK_R;
                WALK_R: if (bump_right) walk_state <= WALK_L;
            endcase
        end
    end
    
    // Falling FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_state <= ON_GROUND;
            saved_direction <= WALK_L;
        end else begin
            case (fall_state)
                ON_GROUND: begin
                    if (!ground) begin
                        fall_state <= FALLING;
                        saved_direction <= walk_state;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        fall_state <= ON_GROUND;
                        walk_state <= saved_direction;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (fall_state == ON_GROUND) && (walk_state == WALK_L);
    assign walk_right = (fall_state == ON_GROUND) && (walk_state == WALK_R);
    assign aaah = (fall_state == FALLING);

endmodule