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
    reg WALK, FALL, DIG;
    reg direction; // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            WALK <= 1'b1;
            FALL <= 1'b0;
            DIG <= 1'b0;
        end else begin
            // Default next state (stay in current state)
            WALK <= WALK;
            FALL <= FALL;
            DIG <= DIG;
            
            // State transitions
            if (WALK) begin
                if (~ground) begin
                    WALK <= 1'b0;
                    FALL <= 1'b1;
                end else if (dig) begin
                    WALK <= 1'b0;
                    DIG <= 1'b1;
                end
            end else if (FALL) begin
                if (ground) begin
                    FALL <= 1'b0;
                    WALK <= 1'b1;
                end
            end else if (DIG) begin
                if (~ground) begin
                    DIG <= 1'b0;
                    FALL <= 1'b1;
                end
            end
        end
    end

    // Direction logic (only changes in WALK state)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end else if (WALK) begin
            // Handle bumps - priority to right if both
            if (bump_right && !bump_left) direction <= 1'b0;
            if (bump_left && !bump_right) direction <= 1'b1;
        end
    end

    // Output assignments
    assign walk_left = WALK & ~direction;
    assign walk_right = WALK & direction;
    assign aaah = FALL;
    assign digging = DIG;

endmodule