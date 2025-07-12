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

    parameter WALK = 0;
    parameter DIG = 1;
    parameter FALL = 2;
    parameter SPLAT = 3;

    reg [1:0] state;
    reg direction;  // 1=left, 0=right
    reg [4:0] fall_count;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1;
            fall_count <= 0;
        end else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 0;
                end else if (dig) begin
                    state <= DIG;
                end else if (bump_left || bump_right) begin
                    direction <= bump_left ? 1 : 0;
                end
            end
            
            DIG: if (!ground) begin
                state <= FALL;
                fall_count <= 0;
            end
            
            FALL: begin
                fall_count <= fall_count + 1;
                if (ground) begin
                    state <= (fall_count > 20) ? SPLAT : WALK;
                end
            end
            
            SPLAT: ; // Stay forever
        endcase
    end

    assign walk_left = (state == WALK) & direction & (state != SPLAT);
    assign walk_right = (state == WALK) & ~direction & (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule