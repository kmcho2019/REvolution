module TopModule(
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

reg [1:0] state;
reg [4:0] fall_counter;
reg [1:0] direction;
reg digging_flag;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // idle
        fall_counter <= 5'b0;
        direction <= 2'b01; // walking left
        digging_flag <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (ground) begin
                    state <= 2'b01; // walking
                end
            end
            2'b01: begin // walking
                if (~ground) begin
                    state <= 2'b10; // falling
                    fall_counter <= 5'b1;
                end else if (dig &&!digging_flag) begin
                    state <= 2'b11; // digging
                    digging_flag <= 1'b1;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    if (direction == 2'b01) begin
                        direction <= 2'b10; // walking right
                    end else begin
                        direction <= 2'b01; // walking left
                    end
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b11; // splattered
                    end else begin
                        state <= 2'b01; // walking
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            2'b11: begin // digging or splattered
                if (state == 2'b11 && digging_flag) begin
                    if (~ground) begin
                        state <= 2'b10; // falling
                        fall_counter <= 5'b1;
                        digging_flag <= 1'b0;
                    end
                end else if (state == 2'b11 &&!digging_flag) begin
                    // do nothing
                end
            end
        endcase
    end
end

always @(*) begin
    walk_left = (state == 2'b01 && direction == 2'b01);
    walk_right = (state == 2'b01 && direction == 2'b10);
    aaah = (state == 2'b10);
    digging = (state == 2'b11 && digging_flag);
end

endmodule