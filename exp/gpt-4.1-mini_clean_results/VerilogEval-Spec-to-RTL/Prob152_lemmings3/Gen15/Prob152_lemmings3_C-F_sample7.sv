module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding (2 bits for clarity)
    localparam WALK = 2'b00,
               FALL = 2'b01,
               DIG  = 2'b10;

    reg [1:0] mode; // FSM mode state: WALK, FALL, DIG
    reg       dir;  // direction: 0 = left, 1 = right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            dir  <= 1'b0; // walk left on reset
        end else begin
            case (mode)
                WALK: begin
                    if (!ground) begin
                        // fall has highest priority
                        mode <= FALL;
                    end else if (dig) begin
                        // dig next priority if on ground and dig=1
                        mode <= DIG;
                    end else if (bump_left || bump_right) begin
                        // bumps handled only in WALK mode
                        // if both bumps, invert direction
                        if (bump_left && bump_right)
                            dir <= ~dir;
                        else if (bump_left)
                            dir <= 1'b1; // walk right
                        else
                            dir <= 1'b0; // walk left
                    end
                    // otherwise remain WALK with same direction
                end

                FALL: begin
                    // stay FALL until ground reappears
                    if (ground) begin
                        mode <= WALK;
                        // direction unchanged after fall as per spec
                    end
                    // bumps and dig ignored during fall
                end

                DIG: begin
                    // continue digging while ground present
                    if (!ground) begin
                        // ground lost while digging, start falling
                        mode <= FALL;
                    end
                    // bumps and dig ignored during dig
                end

                default: begin
                    // Default safe fallback to WALK
                    mode <= WALK;
                    dir <= 1'b0;
                end
            endcase
        end
    end

    // Moore output logic from mode and dir
    assign walk_left  = (mode == WALK) && (dir == 1'b0);
    assign walk_right = (mode == WALK) && (dir == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule