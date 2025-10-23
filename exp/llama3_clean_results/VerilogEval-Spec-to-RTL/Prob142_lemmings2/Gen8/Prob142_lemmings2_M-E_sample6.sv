module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: reset
reg intended_walk_direction;
reg [1:0] delay_counter;

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to walking left
        intended_walk_direction <= 1'b0;
        delay_counter <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    intended_walk_direction <= ~intended_walk_direction;
                end
                if (ground == 1'b0) begin
                    state <= 2'b10; // start falling
                    delay_counter <= 2'b01;
                end else if (intended_walk_direction == 1'b1) begin
                    state <= 2'b01; // walk right
                end
            end
            2'b01: begin // walking right
                if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    intended_walk_direction <= ~intended_walk_direction;
                end
                if (ground == 1'b0) begin
                    state <= 2'b10; // start falling
                    delay_counter <= 2'b01;
                end else if (intended_walk_direction == 1'b0) begin
                    state <= 2'b00; // walk left
                end
            end
            2'b10: begin // falling
                if (ground == 1'b1) begin
                    state <= intended_walk_direction ? 2'b01 : 2'b00; // resume walking
                end else if (delay_counter == 2'b10) begin
                    state <= 2'b10; // continue falling
                end else begin
                    delay_counter <= delay_counter + 1'b1;
                end
            end
            default: begin
                state <= 2'b00; // default to walking left
            end
        endcase
    end
end

always @(*) begin
    if (state == 2'b10) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else if (state == 2'b00) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
    end else if (state == 2'b01) begin
        walk_left = 1'b0;
        walk_right = 1'b1;
        aaah = 1'b0;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
    end
end

endmodule