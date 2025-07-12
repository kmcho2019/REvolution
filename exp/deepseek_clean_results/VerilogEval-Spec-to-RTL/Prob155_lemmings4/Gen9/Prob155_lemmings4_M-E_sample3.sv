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

    // Movement FSM states (direction)
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    reg movement_state;

    // Action FSM states
    parameter WALK = 2'b00;
    parameter DIG = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;
    reg [1:0] action_state;

    // Fall duration counter
    reg [4:0] fall_cycles;

    // Priority decoder outputs
    wire should_fall;
    wire should_dig;
    wire should_change_dir;

    // Priority evaluation (fall > dig > direction change)
    assign should_fall = (action_state == WALK || action_state == DIG) && !ground;
    assign should_dig = (action_state == WALK) && ground && dig;
    assign should_change_dir = (action_state == WALK) && ground && 
                             ((bump_left && !bump_right) || (bump_right && !bump_left));

    // Action FSM transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action_state <= WALK;
            fall_cycles <= 0;
        end else begin
            case (action_state)
                WALK: begin
                    if (should_fall) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end else if (should_dig) begin
                        action_state <= DIG;
                    end
                end
                
                DIG: begin
                    if (should_fall) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_cycles >= 20) begin
                            action_state <= SPLAT;
                        end else begin
                            action_state <= WALK;
                        end
                        fall_cycles <= 0;
                    end else begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end
                
                SPLAT: begin
                    // Permanent state
                    action_state <= SPLAT;
                end
            endcase
        end
    end

    // Movement FSM transition (direction)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            movement_state <= LEFT;
        end else if (action_state == WALK && should_change_dir) begin
            if (bump_left) movement_state <= RIGHT;
            if (bump_right) movement_state <= LEFT;
        end
    end

    // Output logic
    assign walk_left = (action_state == WALK) && (movement_state == LEFT);
    assign walk_right = (action_state == WALK) && (movement_state == RIGHT);
    assign aaah = (action_state == FALL);
    assign digging = (action_state == DIG);

endmodule