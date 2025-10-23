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
reg [1:0] next_state;
reg walk_dir;
reg next_walk_dir;
reg [4:0] fall_counter;
reg splattered;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        walk_dir <= 1'b0;
        fall_counter <= 5'b0;
        splattered <= 1'b0;
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
        if (state == 2'b01) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
        splattered <= splattered || (state == 2'b01 && ground && fall_counter > 5'd20);
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE
            if (ground) begin
                next_state = 2'b10;
                next_walk_dir = 1'b0;
            end else begin
                next_state = 2'b00;
                next_walk_dir = 1'b0;
            end
        end
        2'b01: begin // FALLING
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = 2'b11;
                    next_walk_dir = walk_dir;
                end else begin
                    next_state = 2'b10;
                    next_walk_dir = walk_dir;
                end
            end else begin
                next_state = 2'b01;
                next_walk_dir = walk_dir;
            end
        end
        2'b10: begin // WALKING
            if (!ground) begin
                next_state = 2'b01;
                next_walk_dir = walk_dir;
            end else if (dig) begin
                next_state = 2'b00;
                next_walk_dir = walk_dir;
            end else if (bump_left) begin
                next_state = 2'b10;
                next_walk_dir = 1'b1;
            end else if (bump_right) begin
                next_state = 2'b10;
                next_walk_dir = 1'b0;
            end else begin
                next_state = 2'b10;
                next_walk_dir = walk_dir;
            end
        end
        2'b11: begin // SPLATTERED
            next_state = 2'b11;
            next_walk_dir = walk_dir;
        end
    endcase
end

assign walk_left = (state == 2'b10 && !splattered && walk_dir == 1'b0);
assign walk_right = (state == 2'b10 && !splattered && walk_dir == 1'b1);
assign aaah = (state == 2'b01) && !splattered;
assign digging = (state == 2'b00) && !splattered;

endmodule