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

parameter NUM_STATES = 4;

reg [NUM_STATES-1:0] state; // One-hot encoding: 1'b0001 - Walking left, 1'b0010 - Walking right, 1'b0100 - Digging, 1'b1000 - Falling
reg walk_left_reg, aaah_reg, digging_reg;
reg [1:0] walk_dir; // 2'b00 - Left, 2'b01 - Right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0001; // Reset to walking left
        walk_left_reg <= 1'b1;
        walk_dir <= 2'b00; // Left
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end else begin
        case (1'b1) // One-hot encoding
            state[0]: begin // Walking left
                if (bump_left) begin
                    state <= 1'b0010; // Switch to walking right
                    walk_dir <= 2'b01; // Right
                end else if (!ground) begin
                    state <= 1'b1000; // Start falling
                end else if (dig) begin
                    state <= 1'b0100; // Start digging
                end
            end
            state[1]: begin // Walking right
                if (bump_right) begin
                    state <= 1'b0001; // Switch to walking left
                    walk_dir <= 2'b00; // Left
                end else if (!ground) begin
                    state <= 1'b1000; // Start falling
                end else if (dig) begin
                    state <= 1'b0100; // Start digging
                end
            end
            state[2]: begin // Digging
                if (!ground) begin
                    state <= 1'b1000; // Start falling
                end
            end
            state[3]: begin // Falling
                if (ground) begin
                    state <= {2'b1, walk_dir}; // Resume walking in the same direction
                    aaah_reg <= 1'b0;
                end else begin
                    aaah_reg <= 1'b1;
                end
            end
        endcase
    end
end

assign walk_left = walk_dir == 2'b00;
assign walk_right = walk_dir == 2'b01;
assign aaah = aaah_reg;
assign digging = state[2];

endmodule