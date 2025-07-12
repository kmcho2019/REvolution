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

    parameter WALK_LEFT = 0;
    parameter WALK_RIGHT = 1;
    parameter DIG_LEFT = 2;
    parameter DIG_RIGHT = 3;
    parameter FALL_LEFT = 4;
    parameter FALL_RIGHT = 5;
    parameter SPLAT = 6;

    reg [2:0] state;
    reg [4:0] fall_cycles;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_cycles <= 0;
        end else case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    state <= (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    fall_cycles <= 1;
                end else if (dig) begin
                    state <= (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    state <= bump_left ? WALK_RIGHT : WALK_LEFT;
                end
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    state <= (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    fall_cycles <= 1;
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    if (fall_cycles > 20)
                        state <= SPLAT;
                    else
                        state <= (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    fall_cycles <= 0;
                end else begin
                    fall_cycles <= fall_cycles + 1;
                end
            end
            
            SPLAT: state <= SPLAT; // Terminal state
            
            default: state <= WALK_LEFT; // Safety
        endcase
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule