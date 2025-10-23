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

    reg direction;  // 0=left, 1=right
    reg falling;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // start walking left
            falling <= 0;
        end else begin
            if (!falling) begin
                // Normal walking behavior
                if (!ground) begin
                    falling <= 1;
                end else begin
                    // Change direction if bumped (priority to right if both)
                    if (bump_left) direction <= 1;
                    else if (bump_right) direction <= 0;
                end
            end else begin
                // Falling behavior
                if (ground) falling <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left = (~falling) & (~direction);
    assign walk_right = (~falling) & direction;
    assign aaah = falling;

endmodule