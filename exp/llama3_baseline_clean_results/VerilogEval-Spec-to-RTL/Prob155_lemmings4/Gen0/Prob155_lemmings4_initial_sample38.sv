module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state;
reg [4:0] fall_counter;
reg previous_direction;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // initial state: walking left
        fall_counter <= 5'b0;
        previous_direction <= 1'b0; // initial direction: left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= 2'b11; // digging
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                    previous_direction <= 1'b1; // update previous direction
                end
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= 2'b11; // digging
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                    previous_direction <= 1'b0; // update previous direction
                end
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            2'b10: begin // falling
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'b10000) begin
                        state <= 2'b11; // splattered
                    end else begin
                        state <= previous_direction ? 2'b01 : 2'b00; // resume walking
                    end
                    fall_counter <= 5'b0;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            2'b11: begin // digging or splattered
                if (state == 2'b11 && !ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 5'b1;
                end else if (state == 2'b11 && ground && previous_direction == 1'b0) begin
                    state <= 2'b00; // walking left
                end else if (state == 2'b11 && ground && previous_direction == 1'b1) begin
                    state <= 2'b01; // walking right
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                if (state == 2'b11 && ground) begin
                    digging <= 1'b0;
                end else if (state == 2'b11 && !ground) begin
                    digging <= 1'b0;
                end else begin
                    digging <= 1'b1;
                end
            end
        endcase
    end
end

endmodule