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

reg [4:0] fall_counter;
reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg was_falling;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking left
        fall_counter <= 5'b0;
        was_falling <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 1;
                    was_falling <= 1'b0;
                end else if (dig) begin
                    state <= 2'b11; // digging
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 1;
                    was_falling <= 1'b0;
                end else if (dig) begin
                    state <= 2'b11; // digging
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (fall_counter > 5'b10100) begin
                        state <= 2'b100; // splattered
                    end else begin
                        if (was_falling == 1'b1) begin
                            if (state_before_fall == 2'b00) begin
                                state <= 2'b00; // walking left
                            end else begin
                                state <= 2'b01; // walking right
                            end
                        end else if (state_before_fall == 2'b00) begin
                            state <= 2'b00; // walking left
                        end else begin
                            state <= 2'b01; // walking right
                        end
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                    was_falling <= 1'b1;
                end
            end
            2'b11: begin // digging
                if (!ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 1;
                    was_falling <= 1'b0;
                end else if (!dig) begin
                    if (state_before_dig == 2'b00) begin
                        state <= 2'b00; // walking left
                    end else begin
                        state <= 2'b01; // walking right
                    end
                end
            end
            default: begin // splattered
                state <= 2'b100;
            end
        endcase
    end
end

reg [1:0] state_before_fall;
reg [1:0] state_before_dig;

always @(posedge clk) begin
    if (state == 2'b10 && !was_falling) begin
        if (state == 2'b10 && !was_falling) begin
            if (state_before_fall == 2'b00 || state_before_fall == 2'b01) begin
                state_before_fall <= state_before_fall;
            end else begin
                state_before_fall <= state;
            end
        end else begin
            state_before_fall <= state;
        end
    end else begin
        state_before_fall <= state;
    end

    if (state == 2'b11) begin
        state_before_dig <= state_before_dig;
    end else if (state == 2'b11 && dig) begin
        state_before_dig <= state;
    end else begin
        if (state == 2'b00 || state == 2'b01) begin
            state_before_dig <= state;
        end else begin
            state_before_dig <= state_before_dig;
        end
    end
end

assign walk_left = (state == 2'b00) && !areset;
assign walk_right = (state == 2'b01) && !areset;
assign aaah = (state == 2'b10) && !areset;
assign digging = (state == 2'b11) && !areset;

endmodule