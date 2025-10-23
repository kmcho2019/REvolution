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
    parameter DIR_LEFT  = 0;
    parameter DIR_RIGHT = 1;
    reg direction;

    // Action states
    parameter ACT_WALK  = 0;
    parameter ACT_FALL  = 1;
    parameter ACT_DIG   = 2;
    parameter ACT_SPLAT = 3;
    reg [1:0] action;

    // Fall duration counter
    reg [4:0] fall_counter;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
            action <= ACT_WALK;
            fall_counter <= 0;
        end else begin
            // Update direction (independent of action)
            if (action == ACT_WALK) begin
                case ({bump_left, bump_right})
                    2'b10: direction <= DIR_RIGHT;
                    2'b01: direction <= DIR_LEFT;
                    // On 2'b11, switch direction (implementation choice)
                    2'b11: direction <= ~direction;
                    default: direction <= direction;
                endcase
            end

            // Update action with priority: fall > dig > walk
            case (action)
                ACT_WALK: begin
                    if (!ground) begin
                        action <= ACT_FALL;
                        fall_counter <= 0;
                    end else if (dig) begin
                        action <= ACT_DIG;
                    end
                end

                ACT_FALL: begin
                    if (ground) begin
                        if (fall_counter > 20)
                            action <= ACT_SPLAT;
                        else
                            action <= ACT_WALK;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end

                ACT_DIG: begin
                    if (!ground) begin
                        action <= ACT_FALL;
                        fall_counter <= 0;
                    end
                end

                ACT_SPLAT: begin
                    // Stay in splat forever
                    action <= ACT_SPLAT;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (action == ACT_WALK) && (direction == DIR_LEFT);
    assign walk_right = (action == ACT_WALK) && (direction == DIR_RIGHT);
    assign aaah       = (action == ACT_FALL);
    assign digging    = (action == ACT_DIG);

endmodule