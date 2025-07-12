module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state; // 0: walking, 1: falling, 2: digging
reg walk_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Walking
        walk_dir <= 1'b0; // Left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Walking
                if (!ground) begin
                    state <= 2'b01; // Falling
                    aaah <= 1'b1;
                end else if (dig) begin
                    state <= 2'b10; // Digging
                    digging <= 1'b1;
                end else if (bump_left && !walk_dir) begin
                    walk_dir <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else if (bump_right && walk_dir) begin
                    walk_dir <= 1'b0;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            2'b01: begin // Falling
                if (ground) begin
                    state <= 2'b00; // Walking
                    aaah <= 1'b0;
                end
            end
            2'b10: begin // Digging
                if (!ground) begin
                    state <= 2'b01; // Falling
                    digging <= 1'b0;
                    aaah <= 1'b1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2'b00) begin
        walk_left <= !walk_dir;
        walk_right <= walk_dir;
    end else begin
        walk_left <= 1'b0;
        walk_right <= 1'b0;
    end
    if (state == 2'b10) begin
        digging <= 1'b1;
    end else begin
        digging <= 1'b0;
    end
end

endmodule