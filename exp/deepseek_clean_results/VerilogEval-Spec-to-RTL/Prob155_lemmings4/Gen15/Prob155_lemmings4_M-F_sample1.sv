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

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            // Reset to walking left
            movement_dir <= LEFT;
            action_state <= WALK;
            fall_cycles <= 0;
        end else begin
            case (action_state)
                WALK: begin
                    if (~ground) begin
                        // Highest priority: fall
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        // Next priority: dig
                        action_state <= DIG;
                    end else if (bump_left || bump_right) begin
                        // Lowest priority: bump
                        // Switch direction (prioritize right if both bumps)
                        movement_dir <= bump_left ? RIGHT : LEFT;
                    end
                end

                DIG: begin
                    if (~ground) begin
                        // Transition to fall if ground disappears
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end
                    // Remain digging otherwise
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

    // Output generation - splat overrides everything
    assign walk_left = (action_state != SPLAT) && (action_state == WALK) && (movement_dir == LEFT);
    assign walk_right = (action_state != SPLAT) && (action_state == WALK) && (movement_dir == RIGHT);
    assign aaah = (action_state != SPLAT) && (action_state == FALL);
    assign digging = (action_state != SPLAT) && (action_state == DIG);

endmodule