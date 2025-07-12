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

    reg walking_left;  // 1 = left, 0 = right
    reg falling;       // 1 = falling, 0 = walking

    // Next state logic
    wire next_falling = ~ground & ~falling ? 1'b1 : 
                       ground & falling ? 1'b0 : 
                       falling;

    wire next_walking_left = areset ? 1'b1 :
                            falling ? walking_left :
                            ~ground ? walking_left :
                            (bump_left & walking_left) | (bump_right & ~walking_left) ? ~walking_left :
                            walking_left;

    // State update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_left <= 1'b1;
            falling <= 1'b0;
        end else begin
            walking_left <= next_walking_left;
            falling <= next_falling;
        end
    end

    // Output logic
    assign walk_left = ~falling & walking_left;
    assign walk_right = ~falling & ~walking_left;
    assign aaah = falling;

endmodule