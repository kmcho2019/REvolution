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
                else if (!dig && (bump_left || bump_right)) begin
                    direction <= bump_left;
                end
            end
            
            FALL: if (ground) begin
                state <= WALK;
            end
        endcase
    end

    // Combinatorial outputs
    wire walking = (state == WALK);
    wire falling = (state == FALL);
    wire can_dig = walking && ground && dig;

    assign walk_left  = walking && ~direction && ~can_dig;
    assign walk_right = walking && direction && ~can_dig;
    assign aaah       = falling;
    assign digging    = can_dig;

endmodule