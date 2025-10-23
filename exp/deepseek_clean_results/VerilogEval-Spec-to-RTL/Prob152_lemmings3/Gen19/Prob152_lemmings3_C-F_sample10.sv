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
    reg dig_active;

    // State transitions with clear priority ordering
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            dig_active <= 0;
        end
        else case (state)
            WALK: begin
                if (!ground) begin          // Highest priority: fall
                    state <= FALL;
                    dig_active <= 0;
                end
                else if (dig) begin         // Middle priority: dig
                    dig_active <= 1;
                end
                else if (!dig_active) begin // Lowest priority: bumps
                    if (bump_left) direction <= 1;
                    else if (bump_right) direction <= 0;
                end
            end
            
            FALL: if (ground) begin
                state <= WALK;
                dig_active <= 0;
            end
        endcase
    end

    // Output logic
    assign walk_left  = (state == WALK) & ~direction & ~dig_active;
    assign walk_right = (state == WALK) & direction & ~dig_active;
    assign aaah       = (state == FALL);
    assign digging    = (state == WALK) & dig_active;

endmodule