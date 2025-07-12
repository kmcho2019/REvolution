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
    reg [1:0] next_state;
    reg walk_left_reg;
    reg walk_right_reg;
    reg aaah_reg;
    reg digging_reg;

    // State definitions
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    // Output logic
    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;
    assign digging = digging_reg;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_left_reg <= 1'b1;
            walk_right_reg <= 1'b0;
            aaah_reg <= 1'b0;
            digging_reg <= 1'b0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                        digging_reg <= 1'b0;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end else if (dig) begin
                        state <= DIGGING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b1;
                    end else begin
                        state <= WALK_LEFT;
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end
                end
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                        digging_reg <= 1'b0;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end else if (dig) begin
                        state <= DIGGING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b1;
                    end else begin
                        state <= WALK_RIGHT;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        if (walk_left_reg) begin
                            state <= WALK_LEFT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                        walk_left_reg <= walk_left_reg;
                        walk_right_reg <= walk_right_reg;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end else begin
                        state <= FALLING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                        digging_reg <= 1'b0;
                    end
                end
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                        digging_reg <= 1'b0;
                    end else begin
                        state <= DIGGING;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule