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

    parameter WALK = 0;
    parameter DIG = 1;
    parameter FALL = 2;
    parameter SPLAT = 3;

    reg [1:0] state;
    reg direction;  // 1=left, 0=right
    reg [4:0] fall_count;

    // State transition logic
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
                    direction <= bump_left;
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
            
            SPLAT: state <= SPLAT;
        endcase
    end

    // Output logic (Moore style)
    always @(*) begin
        if (state == SPLAT) begin
            {walk_left, walk_right, aaah, digging} = 4'b0;
        end else begin
            walk_left = (state == WALK) & direction;
            walk_right = (state == WALK) & ~direction;
            aaah = (state == FALL);
            digging = (state == DIG);
        end
    end

endmodule