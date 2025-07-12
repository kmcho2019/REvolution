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

    // Direction states (one-hot encoded)
    localparam DIR_LEFT = 1'b0;
    localparam DIR_RIGHT = 1'b1;
    reg direction;

    // Falling states (one-hot encoded)
    localparam GROUNDED = 1'b0;
    localparam FALLING = 1'b1;
    reg falling;

    // Direction FSM (only active when grounded)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
        end else if (!falling) begin
            case (direction)
                DIR_LEFT:   if (bump_left) direction <= DIR_RIGHT;
                DIR_RIGHT:  if (bump_right) direction <= DIR_LEFT;
            endcase
        end
    end

    // Falling FSM (independent of direction)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            falling <= GROUNDED;
        end else begin
            case (falling)
                GROUNDED:   if (!ground) falling <= FALLING;
                FALLING:    if (ground) falling <= GROUNDED;
            endcase
        end
    end

    // Output logic
    assign walk_left = !falling && (direction == DIR_LEFT);
    assign walk_right = !falling && (direction == DIR_RIGHT);
    assign aaah = falling;

endmodule