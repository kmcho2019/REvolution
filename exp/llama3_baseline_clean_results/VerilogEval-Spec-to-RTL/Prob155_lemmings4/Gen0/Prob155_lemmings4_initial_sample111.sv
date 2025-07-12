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

reg [2:0] state; // 0: Walking Left, 1: Walking Right, 2: Falling, 3: Digging, 4: Splattered
reg [5:0] fall_count; // Counter for falling cycles
reg prev_ground; // Previous value of ground signal

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to Walking Left
        fall_count <= 0;
        prev_ground <= 1'b1;
    end else begin
        case (state)
            0: begin // Walking Left
                if (!ground) begin
                    state <= 2; // Start falling
                    fall_count <= 1;
                    prev_ground <= 1'b1;
                end else if (dig && ground) begin
                    state <= 3; // Start digging
                end else if (bump_left) begin
                    state <= 1; // Switch to Walking Right
                end else if (bump_right) begin
                    // No change, already walking left
                end
            end
            1: begin // Walking Right
                if (!ground) begin
                    state <= 2; // Start falling
                    fall_count <= 1;
                    prev_ground <= 1'b1;
                end else if (dig && ground) begin
                    state <= 3; // Start digging
                end else if (bump_right) begin
                    state <= 0; // Switch to Walking Left
                end else if (bump_left) begin
                    // No change, already walking right
                end
            end
            2: begin // Falling
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // Splatter
                    end else begin
                        // Resume walking in previous direction
                        if (prev_ground) begin
                            if (bump_left) begin
                                state <= 1;
                            end else if (bump_right) begin
                                state <= 0;
                            end else if (dig) begin
                                state <= 3;
                            end else begin
                                // No change, resume previous direction
                                if (prev_ground == 1'b1) begin
                                    if (bump_left) begin
                                        state <= 1;
                                    end else begin
                                        state <= 0;
                                    end
                                end else begin
                                    state <= 0;
                                end
                            end
                        end
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            3: begin // Digging
                if (!ground) begin
                    state <= 2; // Start falling
                    fall_count <= 1;
                    prev_ground <= 1'b1;
                end else begin
                    // Continue digging
                end
            end
            4: begin // Splattered
                // No change, stay splattered
            end
        endcase
    end
end

assign walk_left = (state == 0);
assign walk_right = (state == 1);
assign aaah = (state == 2);
assign digging = (state == 3);

always @(posedge clk) begin
    prev_ground <= ground;
end

endmodule