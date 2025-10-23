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

reg [1:0] state; // 0: walking left, 1: walking right, 2: digging
reg prev_direction; // 0: left, 1: right
reg falling;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        falling <= 0;
        prev_direction <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (!ground) begin
                    state <= 0; // keep walking left
                    falling <= 1;
                end else if (dig) begin
                    state <= 2; // start digging
                    falling <= 0;
                end else if (bump_left) begin
                    state <= 1; // switch to walking right
                    falling <= 0;
                end else if (bump_right) begin
                    state <= 0; // keep walking left
                    falling <= 0;
                end else begin
                    state <= 0; // keep walking left
                    falling <= 0;
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 1; // keep walking right
                    falling <= 1;
                end else if (dig) begin
                    state <= 2; // start digging
                    falling <= 0;
                end else if (bump_left) begin
                    state <= 1; // keep walking right
                    falling <= 0;
                end else if (bump_right) begin
                    state <= 0; // switch to walking left
                    falling <= 0;
                end else begin
                    state <= 1; // keep walking right
                    falling <= 0;
                end
            end
            2: begin // digging
                if (!ground) begin
                    state <= prev_direction; // stop digging and resume walking
                    falling <= 1;
                end else begin
                    state <= 2; // keep digging
                    falling <= 0;
                end
            end
            default: begin
                state <= 0; // default to walking left
                falling <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 0) begin
        prev_direction <= 0; // update previous direction
    end else if (state == 1) begin
        prev_direction <= 1; // update previous direction
    end
end

assign walk_left = (state == 0 &&!falling);
assign walk_right = (state == 1 &&!falling);
assign aaah = falling;
assign digging = (state == 2);

endmodule