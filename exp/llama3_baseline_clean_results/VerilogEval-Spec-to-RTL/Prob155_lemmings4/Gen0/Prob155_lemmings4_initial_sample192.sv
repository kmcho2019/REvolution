module TopModule(
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

reg [2:0] state; // 0: IDLE, 1: FALLING, 2: DIGGING, 3: SPLATTERED
reg [5:0] fall_count;
reg direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        direction <= 0;
        fall_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!ground) begin
                    state <= 1;
                end else if (dig && ground) begin
                    state <= 2;
                end else if (bump_left && !bump_right) begin
                    direction <= 1;
                end else if (bump_right && !bump_left) begin
                    direction <= 0;
                end else if (bump_left && bump_right) begin
                    direction <= ~direction;
                end
            end
            1: begin // FALLING
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 3;
                    end else begin
                        state <= 0;
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            2: begin // DIGGING
                if (!ground) begin
                    state <= 1;
                end
            end
            3: begin // SPLATTERED
                // do nothing
            end
        endcase
    end
end

assign walk_left = (state == 0 && !direction);
assign walk_right = (state == 0 && direction);
assign aaah = (state == 1);
assign digging = (state == 2);

endmodule