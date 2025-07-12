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

    // States
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;

    reg state;
    reg direction; // 0=left, 1=right
    wire bump = bump_left | bump_right;
    wire walking = (state == WALK);
    wire can_dig = walking & ground;
    wire can_bump = walking & ground & ~dig;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end
        else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                end
                else if (can_bump && bump) begin
                    direction <= bump_left;
                end
            end
            
            FALL: if (ground) begin
                state <= WALK;
            end
        endcase
    end

    // Output logic
    wire walking_left = walking & ~direction;
    wire walking_right = walking & direction;
    assign walk_left = walking_left & ~dig;
    assign walk_right = walking_right & ~dig;
    assign aaah = (state == FALL);
    assign digging = can_dig & dig;

endmodule