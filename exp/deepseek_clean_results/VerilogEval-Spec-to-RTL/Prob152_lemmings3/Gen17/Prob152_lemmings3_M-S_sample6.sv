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

    reg [1:0] state; // 00:WALK, 01:FALL, 10:DIG
    reg direction;    // 0:left, 1:right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            direction <= 0;
        end else case (state)
            2'b00: begin // WALK
                if (!ground) state <= 2'b01; // fall first
                else if (dig) state <= 2'b10; // then dig
                else if (bump_left || bump_right) direction <= direction ^ (bump_left || bump_right);
            end
            2'b01: if (ground) state <= 2'b00; // FALL->WALK when ground
            2'b10: if (!ground) state <= 2'b01; // DIG->FALL when no ground
        endcase
    end

    assign walk_left = (state == 2'b00) && !direction;
    assign walk_right = (state == 2'b00) && direction;
    assign aaah = (state == 2'b01);
    assign digging = (state == 2'b10);

endmodule