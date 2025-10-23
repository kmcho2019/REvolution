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

    // Movement direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    reg movement_dir;  // Current walking direction

    // Action states
    parameter WALK = 2'b00;
    parameter DIG  = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;
    reg [1:0] action_state;

    // Fall duration counter
    reg [4:0] fall_cycles;

    // Priority resolution
    wire should_fall = ~ground;
    wire should_dig = dig && ground && (action_state == WALK);
    wire should_bump = (bump_left || bump_right) && (action_state == WALK);

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            // Reset to walking left
            movement_dir <= LEFT;
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
                    end else if (should_bump) begin
                        // Switch direction when bumped
                        movement_dir <= bump_left ? RIGHT : LEFT;
                    end
                end

                DIG: begin
                    if (should_fall) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end
                    // Remain digging until ground disappears
                end

                FALL: begin
                    if (ground) begin
                        // Check if we've fallen too long
                        if (fall_cycles > 20) begin
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
                    // Permanent state - no transitions
                end
            endcase
        end
    end

    // Output generation
    assign walk_left = (action_state == WALK) && (movement_dir == LEFT) && (action_state != SPLAT);
    assign walk_right = (action_state == WALK) && (movement_dir == RIGHT) && (action_state != SPLAT);
    assign aaah = (action_state == FALL);
    assign digging = (action_state == DIG);

endmodule