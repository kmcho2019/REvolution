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

reg [1:0] state;
reg walk_dir; // 1: walk right, 0: walk left
reg is_digging;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        walk_dir <= 1'b0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10;
                end else if (dig) begin
                    state <= 2'b10;
                    is_digging <= 1'b1;
                end else if (bump_right) begin
                    walk_dir <= 1'b1;
                    state <= 2'b01;
                end else if (bump_left) begin
                    walk_dir <= 1'b0;
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10;
                end else if (dig) begin
                    state <= 2'b10;
                    is_digging <= 1'b1;
                end else if (bump_left) begin
                    walk_dir <= 1'b0;
                    state <= 2'b00;
                end else if (bump_right) begin
                    walk_dir <= 1'b1;
                end
            end
            2'b10: begin // falling or digging
                if (ground) begin
                    state <= walk_dir ? 2'b01 : 2'b00;
                    is_digging <= 1'b0;
                end else if (is_digging) begin
                    if (!ground) begin
                        is_digging <= 1'b0;
                    end
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

always @ (*) begin
    walk_left = (state == 2'b00 || (state == 2'b10 && !is_digging && !walk_dir));
    walk_right = (state == 2'b01 || (state == 2'b10 && !is_digging && walk_dir));
    aaah = (state == 2'b10 && !is_digging);
    digging = is_digging;
end

endmodule