module TopModule(
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

reg [1:0] state; // 00: WALK_LEFT, 01: WALK_RIGHT, 10: FALL, 11: DIG
reg [4:0] fall_counter;
reg last_ground;
reg last_dig;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALK_LEFT
        fall_counter <= 5'b0;
        last_ground <= 1'b1;
        last_dig <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2'b10; // FALL
                    fall_counter <= 5'b1;
                end else if (dig && !last_dig) begin
                    state <= 2'b11; // DIG
                end else if (bump_left || (bump_left && bump_right)) begin
                    state <= 2'b01; // WALK_RIGHT
                end
            end
            2'b01: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2'b10; // FALL
                    fall_counter <= 5'b1;
                end else if (dig && !last_dig) begin
                    state <= 2'b11; // DIG
                end else if (bump_right || (bump_left && bump_right)) begin
                    state <= 2'b00; // WALK_LEFT
                end
            end
            2'b10: begin // FALL
                if (ground) begin
                    if (fall_counter > 5'b10100) begin // 20 clock cycles
                        state <= 2'b11; // SPLATTER
                    end else begin
                        if (last_ground == 1'b0) begin
                            state <= 2'b00; // WALK_LEFT
                        end else if (last_ground == 1'b1) begin
                            state <= 2'b01; // WALK_RIGHT
                        end
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            2'b11: begin // DIG
                if (!ground) begin
                    state <= 2'b10; // FALL
                    fall_counter <= 5'b1;
                end
            end
        endcase
        last_ground <= ground;
        last_dig <= dig;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // FALL
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin // DIG
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule