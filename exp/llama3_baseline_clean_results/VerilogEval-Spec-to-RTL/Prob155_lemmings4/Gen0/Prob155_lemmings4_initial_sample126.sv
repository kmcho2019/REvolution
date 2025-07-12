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

reg [1:0] state; // 0: IDLE, 1: FALLING, 2: DIGGING, 3: SPLATTERED
reg [1:0] dir; // 0: LEFT, 1: RIGHT
reg [4:0] fall_count; // counter for falling clock cycles

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // IDLE
        dir <= 2'b0; // LEFT
        fall_count <= 5'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_count <= 5'b1;
                end else if (dig) begin
                    state <= 2'b10; // DIGGING
                end else if (bump_left && bump_right) begin
                    dir <= ~dir; // switch direction
                end else if (bump_left) begin
                    dir <= 2'b1; // RIGHT
                end else if (bump_right) begin
                    dir <= 2'b0; // LEFT
                end
            end
            2'b01: begin // FALLING
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= 2'b11; // SPLATTERED
                    end else begin
                        state <= 2'b00; // IDLE
                        fall_count <= 5'b0;
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            2'b10: begin // DIGGING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_count <= 5'b1;
                end
            end
            2'b11: begin // SPLATTERED
                // stay in this state forever
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE
            walk_left = (dir == 2'b0);
            walk_right = (dir == 2'b1);
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b10: begin // DIGGING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        2'b11: begin // SPLATTERED
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule