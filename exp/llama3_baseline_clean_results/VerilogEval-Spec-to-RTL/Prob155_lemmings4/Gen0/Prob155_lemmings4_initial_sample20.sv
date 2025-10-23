module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [4:0] fall_count; // counter to count the number of clock cycles the Lemming has been falling
reg [1:0] direction; // 0: walking left, 1: walking right
reg [1:0] state; // 0: IDLE, 1: FALL, 2: DIG, 3: SPLATTER

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to IDLE state
        direction <= 2'b0; // reset to walking left
        fall_count <= 5'b0; // reset fall counter
        walk_left <= 1'b1; // reset walk_left to 1
        walk_right <= 1'b0; // reset walk_right to 0
        aaah <= 1'b0; // reset aaah to 0
        digging <= 1'b0; // reset digging to 0
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~ground) begin
                    state <= 2'b01; // transition to FALL state
                    fall_count <= 5'b1; // start counting fall time
                    aaah <= 1'b1; // set aaah to 1
                    walk_left <= 1'b0; // clear walk_left
                    walk_right <= 1'b0; // clear walk_right
                    digging <= 1'b0; // clear digging
                end else if (dig && ground) begin
                    state <= 2'b10; // transition to DIG state
                    digging <= 1'b1; // set digging to 1
                    walk_left <= 1'b0; // clear walk_left
                    walk_right <= 1'b0; // clear walk_right
                    aaah <= 1'b0; // clear aaah
                end else if (bump_left) begin
                    direction <= 2'b1; // change direction to walking right
                end else if (bump_right) begin
                    direction <= 2'b0; // change direction to walking left
                end
                if (direction == 2'b0) begin
                    walk_left <= 1'b1; // set walk_left to 1
                    walk_right <= 1'b0; // clear walk_right
                end else begin
                    walk_left <= 1'b0; // clear walk_left
                    walk_right <= 1'b1; // set walk_right to 1
                end
            end
            2'b01: begin // FALL state
                fall_count <= fall_count + 1'b1; // increment fall counter
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= 2'b11; // transition to SPLATTER state
                        walk_left <= 1'b0; // clear walk_left
                        walk_right <= 1'b0; // clear walk_right
                        aaah <= 1'b0; // clear aaah
                        digging <= 1'b0; // clear digging
                    end else begin
                        state <= 2'b00; // transition back to IDLE state
                        aaah <= 1'b0; // clear aaah
                        if (direction == 2'b0) begin
                            walk_left <= 1'b1; // set walk_left to 1
                            walk_right <= 1'b0; // clear walk_right
                        end else begin
                            walk_left <= 1'b0; // clear walk_left
                            walk_right <= 1'b1; // set walk_right to 1
                        end
                    end
                end
            end
            2'b10: begin // DIG state
                if (~ground) begin
                    state <= 2'b01; // transition to FALL state
                    fall_count <= 5'b1; // start counting fall time
                    aaah <= 1'b1; // set aaah to 1
                    walk_left <= 1'b0; // clear walk_left
                    walk_right <= 1'b0; // clear walk_right
                    digging <= 1'b0; // clear digging
                end
            end
            2'b11: begin // SPLATTER state
                walk_left <= 1'b0; // clear walk_left
                walk_right <= 1'b0; // clear walk_right
                aaah <= 1'b0; // clear aaah
                digging <= 1'b0; // clear digging
            end
        endcase
    end
end

endmodule