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
    reg is_digging;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            is_digging <= 0;
        end
        else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                    is_digging <= 0;
                end
                else if (dig) begin
                    is_digging <= 1;
                end
                else if (!is_digging) begin
                    if (bump_left) direction <= 1;
                    else if (bump_right) direction <= 0;
                end
            end
            
            FALL: if (ground) begin
                state <= WALK;
                is_digging <= 0;
            end
        endcase
    end

    // Outputs
    assign walk_left = (state == WALK) & ~direction & ~is_digging;
    assign walk_right = (state == WALK) & direction & ~is_digging;
    assign aaah = (state == FALL);
    assign digging = (state == WALK) & is_digging;

endmodule