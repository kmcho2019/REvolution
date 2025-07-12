module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // One-hot states with direction combined
    parameter WALK_LEFT  = 3'b100;
    parameter WALK_RIGHT = 3'b010;
    parameter FALL       = 3'b001;
    parameter DIG_LEFT   = 3'b110;
    parameter DIG_RIGHT  = 3'b011;
    
    reg [2:0] state;

    // Clock gating for direction changes (only in WALK states)
    wire dir_clk = clk & (state[2] | state[1]);

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) state <= FALL;
                else if (dig) state <= (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
            end
            DIG_LEFT, DIG_RIGHT: if (!ground) state <= FALL;
            FALL: if (ground) state <= (state[2]) ? WALK_LEFT : WALK_RIGHT;
            default: state <= WALK_LEFT;
        endcase
    end

    // Direction toggle (only in WALK states)
    always @(posedge dir_clk, posedge areset) begin
        if (areset) begin
            state[1:0] <= 2'b00; // WALK_LEFT
        end
        else if (state[2] && bump_left) begin // WALK_LEFT
            state[2] <= 0;
            state[1] <= 1;
        end
        else if (state[1] && bump_right) begin // WALK_RIGHT
            state[2] <= 1;
            state[1] <= 0;
        end
    end

    // Registered outputs
    always @(posedge clk) begin
        walk_left  <= state == WALK_LEFT;
        walk_right <= state == WALK_RIGHT;
        aaah       <= state == FALL;
        digging    <= state == DIG_LEFT || state == DIG_RIGHT;
    end

endmodule