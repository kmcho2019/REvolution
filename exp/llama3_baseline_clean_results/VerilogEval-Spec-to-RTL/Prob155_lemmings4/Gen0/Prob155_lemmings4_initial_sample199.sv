module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    input           dig,
    output          walk_left,
    output          walk_right,
    output          aaah,
    output          digging
);

    reg [1:0] state; // idle_left (2'b00), idle_right (2'b01), falling (2'b10), splattered (2'b11)
    reg [4:0] fall_counter; // counts the number of clock cycles the Lemming has been falling
    reg [4:0] dig_counter; // counts the number of clock cycles the Lemming has been digging
    reg        direction; // 1 for right, 0 for left

    // initialize the state to idle_left on reset
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            state <= 2'b00;
            direction <= 1'b0;
            fall_counter <= 5'b0;
            dig_counter <= 5'b0;
        end
        else if (state == 2'b00 || state == 2'b01) begin // walking
            if (!ground) begin // fall
                state <= 2'b10;
                direction <= direction;
                fall_counter <= 5'b1;
                dig_counter <= 5'b0;
            end
            else if (dig) begin // dig
                state <= 2'b01;
                direction <= direction;
                fall_counter <= 5'b0;
                dig_counter <= 5'b1;
            end
            else if (bump_left && !bump_right) begin // bump left
                state <= 2'b01;
                direction <= 1'b1;
                fall_counter <= 5'b0;
                dig_counter <= 5'b0;
            end
            else if (!bump_left && bump_right) begin // bump right
                state <= 2'b00;
                direction <= 1'b0;
                fall_counter <= 5'b0;
                dig_counter <= 5'b0;
            end
            else if (bump_left && bump_right) begin // bump both
                state <= (direction) ? 2'b00 : 2'b01;
                direction <= ~direction;
                fall_counter <= 5'b0;
                dig_counter <= 5'b0;
            end
        end
        else if (state == 2'b10) begin // falling
            if (ground && fall_counter >= 5'd20) begin // splatter
                state <= 2'b11;
                direction <= 1'b0;
                fall_counter <= 5'b0;
                dig_counter <= 5'b0;
            end
            else if (ground) begin // land
                state <= (direction) ? 2'b01 : 2'b00;
                fall_counter <= 5'b0;
                dig_counter <= 5'b0;
            end
            else begin // continue falling
                fall_counter <= fall_counter + 5'b1;
            end
        end
        else if (state == 2'b11) begin // splattered
            state <= 2'b11;
        end
    end

    assign walk_left = (state == 2'b00 && !dig);
    assign walk_right = (state == 2'b01 && !dig);
    assign aaah = (state == 2'b10);
    assign digging = (state == 2'b01 && dig);

endmodule