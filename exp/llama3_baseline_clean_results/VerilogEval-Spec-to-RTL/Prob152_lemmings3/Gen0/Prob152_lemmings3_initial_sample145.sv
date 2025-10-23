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

    reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging
    reg [1:0] next_state;
    reg walk_left_reg;
    reg walk_right_reg;
    reg aaah_reg;
    reg digging_reg;

    // assign default values
    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;
    assign digging = digging_reg;

    always @(*) begin
        case (state)
            2'b00: begin // walking left
                walk_left_reg = 1'b1;
                walk_right_reg = 1'b0;
                aaah_reg = 1'b0;
                digging_reg = 1'b0;
                if (!ground) begin
                    next_state = 2'b10; // falling
                end else if (dig) begin
                    next_state = 2'b11; // digging
                end else if (bump_left) begin
                    next_state = 2'b01; // walking right
                end else if (bump_right) begin
                    next_state = 2'b00; // walking left
                end else begin
                    next_state = 2'b00; // walking left
                end
            end
            2'b01: begin // walking right
                walk_left_reg = 1'b0;
                walk_right_reg = 1'b1;
                aaah_reg = 1'b0;
                digging_reg = 1'b0;
                if (!ground) begin
                    next_state = 2'b10; // falling
                end else if (dig) begin
                    next_state = 2'b11; // digging
                end else if (bump_left) begin
                    next_state = 2'b00; // walking left
                end else if (bump_right) begin
                    next_state = 2'b01; // walking right
                end else begin
                    next_state = 2'b01; // walking right
                end
            end
            2'b10: begin // falling
                walk_left_reg = 1'b0;
                walk_right_reg = 1'b0;
                aaah_reg = 1'b1;
                digging_reg = 1'b0;
                if (ground) begin
                    next_state = state[1] ? 2'b01 : 2'b00; // resume walking
                end else begin
                    next_state = 2'b10; // continue falling
                end
            end
            2'b11: begin // digging
                walk_left_reg = 1'b0;
                walk_right_reg = 1'b0;
                aaah_reg = 1'b0;
                digging_reg = 1'b1;
                if (!ground) begin
                    next_state = 2'b10; // falling
                end else begin
                    next_state = 2'b11; // continue digging
                end
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

endmodule