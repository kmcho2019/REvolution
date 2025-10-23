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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg original_direction; // 0: left, 1: right
reg digging_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        original_direction <= 0; // reset to walking left
        digging_reg <= 0; // reset to not digging
    end else begin
        case (state)
            0: begin // walking left
                if (!ground) begin
                    state <= 2; // start falling
                    original_direction <= 0; // save original direction
                end else if (dig &&!digging_reg) begin
                    digging_reg <= 1; // start digging
                end else if (bump_right) begin
                    state <= 1; // switch to walking right
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 2; // start falling
                    original_direction <= 1; // save original direction
                end else if (dig &&!digging_reg) begin
                    digging_reg <= 1; // start digging
                end else if (bump_left) begin
                    state <= 0; // switch to walking left
                end
            end
            2: begin // falling
                if (ground) begin
                    state <= original_direction; // resume walking
                    digging_reg <= 0; // stop digging
                end else if (digging_reg) begin
                    digging_reg <= 0; // stop digging
                end
            end
            default: begin
                state <= 0; // default to walking left
            end
        endcase
    end
end

assign walk_left = (state == 0 &&!digging_reg);
assign walk_right = (state == 1 &&!digging_reg);
assign aaah = (state == 2);
assign digging = digging_reg;

endmodule