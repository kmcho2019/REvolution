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
    reg dir_left;  // 1=left, 0=right
    reg [4:0] fall_cycles;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir_left <= 1;
            fall_cycles <= 0;
        end else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                    fall_cycles <= 0;
                end else if (dig) begin
                    state <= DIG;
                end else if (bump_left || bump_right) begin
                    // Toggle direction if both bumps, else follow bump
                    dir_left <= (bump_left && bump_right) ? ~dir_left : 
                               (bump_left ? 1 : 0);
                end
            end
            
            DIG: begin
                if (!ground) begin
                    state <= FALL;
                    fall_cycles <= 0;
                end
            end
            
            FALL: begin
                if (ground) begin
                    state <= (fall_cycles > 20) ? SPLAT : WALK;
                    fall_cycles <= 0;
                end else begin
                    fall_cycles <= fall_cycles + 1;
                end
            end
            
            SPLAT: state <= SPLAT; // Stay forever
        endcase
    end

    assign walk_left = (state == WALK) && dir_left && (state != SPLAT);
    assign walk_right = (state == WALK) && !dir_left && (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule