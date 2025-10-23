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

    // Output logic
    assign walk_left  = (state == WALK) & ~direction & ~dig;
    assign walk_right = (state == WALK) & direction & ~dig;
    assign aaah       = (state == FALL);
    assign digging    = (state == WALK) & dig & ground;

endmodule