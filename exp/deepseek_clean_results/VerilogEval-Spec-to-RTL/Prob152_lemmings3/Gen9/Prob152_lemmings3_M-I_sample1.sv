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

    // One-hot state encoding with direction merged
    parameter WALK_L = 3'b001;
    parameter WALK_R = 3'b010;
    parameter FALL   = 3'b100;
    parameter DIG_L  = 3'b101;
    parameter DIG_R  = 3'b110;
    
    reg [2:0] state;

    // Clock gating for direction changes (only in WALK states)
    wire direction_change = (state == WALK_L || state == WALK_R) && 
                          ((bump_left && state == WALK_L) || 
                           (bump_right && state == WALK_R));

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end else case (state)
            WALK_L, WALK_R: begin
                if (!ground) state <= FALL;
                else if (dig) state <= (state == WALK_L) ? DIG_L : DIG_R;
                else if (direction_change) state <= (state == WALK_L) ? WALK_R : WALK_L;
            end
            FALL: if (ground) state <= (state[0]) ? WALK_L : WALK_R; // Last bit indicates original direction
            DIG_L, DIG_R: if (!ground) state <= FALL;
        endcase
    end

    // Direct output assignments from state
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule