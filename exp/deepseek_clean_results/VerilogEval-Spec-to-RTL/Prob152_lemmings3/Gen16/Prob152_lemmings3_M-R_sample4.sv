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

    // State registers
    reg walking_left;  // 1 = left, 0 = right
    reg is_falling;
    reg is_digging;

    // Next state logic (combinational)
    wire next_walking_left;
    wire next_is_falling;
    wire next_is_digging;

    // Priority: fall > dig > bump
    assign next_is_falling = is_falling ? ~ground : ~ground;
    assign next_is_digging = is_falling ? 1'b0 : 
                           (~ground ? 1'b0 : 
                           (dig ? 1'b1 : is_digging));
    
    assign next_walking_left = is_falling ? walking_left :
                             (is_digging ? walking_left :
                             (bump_left ? 1'b0 :
                             (bump_right ? 1'b1 : walking_left)));

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_left <= 1'b1;
            is_falling <= 1'b0;
            is_digging <= 1'b0;
        end else begin
            walking_left <= next_walking_left;
            is_falling <= next_is_falling;
            is_digging <= next_is_digging;
        end
    end

    // Output logic
    assign walk_left = ~is_falling & walking_left & ~is_digging;
    assign walk_right = ~is_falling & ~walking_left & ~is_digging;
    assign aaah = is_falling;
    assign digging = ~is_falling & is_digging;

endmodule