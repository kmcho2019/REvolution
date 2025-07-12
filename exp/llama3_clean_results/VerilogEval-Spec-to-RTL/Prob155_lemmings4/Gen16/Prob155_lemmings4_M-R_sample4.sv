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
reg walking_direction;

always @(posedge areset) begin
    state <= 2'b00; // WALKING
    fall_counter <= 5'b0;
    walking_direction <= 1'b1; // walking left
end

always_ff @(posedge clk) begin
    if (state == 2'b00) begin // WALKING
        if (~ground) begin
            state <= 2'b01; // FALLING
        end else if (dig) begin
            state <= 2'b10; // DIGGING
        end else if (bump_left || bump_right) begin
            walking_direction <= ~walking_direction;
        end
    end else if (state == 2'b01) begin // FALLING
        fall_counter <= fall_counter + 1'b1;
        if (ground) begin
            if (fall_counter > 5'd20) begin
                state <= 2'b11; // SPLATTERED
            end else begin
                state <= 2'b00; // WALKING
            end
            fall_counter <= 5'b0;
        end
    end else if (state == 2'b10) begin // DIGGING
        if (~ground) begin
            state <= 2'b01; // FALLING
        end
    end else if (state == 2'b11) begin // SPLATTERED
        // do nothing
    end
end

assign walk_left = (state == 2'b00 && walking_direction) || (state == 2'b10 && walking_direction);
assign walk_right = (state == 2'b00 && ~walking_direction) || (state == 2'b10 && ~walking_direction);
assign aaah = state == 2'b01;
assign digging = state == 2'b10;

endmodule