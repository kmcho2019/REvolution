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

    // One-hot state encoding
    reg WALK, FALL, DIG, SPLAT;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // Next state and direction logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            WALK <= 1;
            FALL <= 0;
            DIG <= 0;
            SPLAT <= 0;
            direction <= 0;
            fall_counter <= 0;
        end else if (~SPLAT) begin
            // State transitions with priority: fall > dig > bump
            if (WALK) begin
                if (~ground) begin
                    WALK <= 0;
                    FALL <= 1;
                    fall_counter <= 1;
                end else if (dig) begin
                    WALK <= 0;
                    DIG <= 1;
                end else begin
                    // Handle bump only if not falling or digging
                    if (bump_left && ~direction) direction <= 1;
                    if (bump_right && direction) direction <= 0;
                end
            end
            else if (FALL) begin
                if (ground) begin
                    FALL <= 0;
                    if (fall_counter > 20) begin
                        SPLAT <= 1;
                    end else begin
                        WALK <= 1;
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            else if (DIG) begin
                if (~ground) begin
                    DIG <= 0;
                    FALL <= 1;
                    fall_counter <= 1;
                end
            end
        end
    end

    // Output logic - continuous assignments
    assign walk_left = WALK & ~direction & ~SPLAT;
    assign walk_right = WALK & direction & ~SPLAT;
    assign aaah = FALL;
    assign digging = DIG;

endmodule