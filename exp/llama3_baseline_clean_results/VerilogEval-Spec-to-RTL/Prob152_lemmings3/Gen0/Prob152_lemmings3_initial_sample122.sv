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
reg original_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking left
        original_direction <= 1'b0; // left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10; // falling
                    original_direction <= 1'b0; // left
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= 2'b11; // digging
                    original_direction <= 1'b0; // left
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_right) begin
                    // do nothing, already walking left
                end else begin
                    // do nothing, already walking left
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10; // falling
                    original_direction <= 1'b1; // right
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= 2'b11; // digging
                    original_direction <= 1'b1; // right
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_left) begin
                    // do nothing, already walking right
                end else begin
                    // do nothing, already walking right
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (original_direction) begin
                        state <= 2'b01; // walking right
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else begin
                        state <= 2'b00; // walking left
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    // do nothing, already falling
                end
            end
            2'b11: begin // digging
                if (!ground) begin
                    state <= 2'b10; // falling
                    original_direction <= original_direction; // preserve original direction
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    // do nothing, already digging
                end
            end
        endcase
    end
end

endmodule