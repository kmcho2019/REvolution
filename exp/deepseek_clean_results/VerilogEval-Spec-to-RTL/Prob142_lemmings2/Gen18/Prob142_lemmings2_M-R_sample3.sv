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

    // State definitions
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    // State registers
    reg direction;  // LEFT or RIGHT
    reg falling;
    
    // Next state logic
    always @(*) begin
        if (!ground) begin
            falling = 1'b1;
        end else begin
            falling = 1'b0;
        end
    end
    
    // Direction update logic
    always @(*) begin
        if (areset) begin
            direction = LEFT;
        end else if (!falling && ground) begin
            case ({direction, bump_left, bump_right})
                3'b0_1_0: direction = RIGHT;  // Walking left and bumped left
                3'b0_1_1: direction = RIGHT;  // Walking left and bumped both
                3'b1_0_1: direction = LEFT;   // Walking right and bumped right
                3'b1_1_1: direction = LEFT;   // Walking right and bumped both
                default: direction = direction; // No bump or invalid bump
            endcase
        end
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= LEFT;
            falling <= 1'b0;
        end else begin
            direction <= direction;
            falling <= falling;
        end
    end
    
    // Output assignments
    assign walk_left = !falling && (direction == LEFT);
    assign walk_right = !falling && (direction == RIGHT);
    assign aaah = falling;

endmodule