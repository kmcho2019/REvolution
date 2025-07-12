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
reg walking_left_direction;
reg [4:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        walking_left_direction <= 1'b1;
        fall_counter <= 5'b0;
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (~ground) begin
                    state <= 2'b01;
                    fall_counter <= 1'b1;
                end else if (dig) begin
                    // Do nothing, already walking
                end else if (bump_left ^ bump_right) begin
                    walking_left_direction <= ~walking_left_direction;
                end else if (bump_left && bump_right) begin
                    walking_left_direction <= ~walking_left_direction;
                end
            end
            2'b01: begin // FALLING
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b10;
                    end else begin
                        state <= 2'b00;
                        fall_counter <= 5'b0;
                    end
                end
            end
            2'b10: begin // SPLATTERED
                state <= 2'b10;
            end
        endcase
    end
end

assign walk_left = (state == 2'b00 && walking_left_direction)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b00 && ~walking_left_direction)? 1'b1 : 1'b0;
assign aaah = (state == 2'b01)? 1'b1 : 1'b0;
assign digging = (state == 2'b00 && dig)? 1'b1 : 1'b0;

endmodule