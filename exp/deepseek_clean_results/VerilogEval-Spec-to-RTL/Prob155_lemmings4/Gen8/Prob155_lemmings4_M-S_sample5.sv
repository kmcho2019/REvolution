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
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_counter <= 0;
        end else case (state)
            WALK: begin
                if (~ground) begin
                    state <= FALL;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIG;
                end else if (bump_left || bump_right) begin
                    direction <= bump_left ? 1 : 0;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    state <= FALL;
                    fall_counter <= 1;
                end
            end
            
            FALL: begin
                if (ground) begin
                    state <= (fall_counter > 20) ? SPLAT : WALK;
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            
            SPLAT: begin
                // Stay in SPLAT forever
                state <= SPLAT;
            end
        endcase
    end

    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule