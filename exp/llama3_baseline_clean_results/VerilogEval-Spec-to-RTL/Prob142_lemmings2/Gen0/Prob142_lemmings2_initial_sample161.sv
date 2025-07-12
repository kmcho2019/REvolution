module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// State encoding: 00 - walk_left, 01 - walk_right, 10 - falling
reg [1:0] state;
reg [0:0] prev_walk_dir; // 0 for left, 1 for right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initialize to walk_left
        prev_walk_dir <= 0;
    end else begin
        case (state)
            2'b00: begin // Walking left
                if (~ground) begin
                    state <= 2'b10; // Start falling
                    prev_walk_dir <= 0; // Store previous direction
                end else if (bump_left) begin
                    state <= 2'b01; // Switch to walking right
                end
            end
            2'b01: begin // Walking right
                if (~ground) begin
                    state <= 2'b10; // Start falling
                    prev_walk_dir <= 1; // Store previous direction
                end else if (bump_right) begin
                    state <= 2'b00; // Switch to walking left
                end
            end
            2'b10: begin // Falling
                if (ground) begin
                    if (prev_walk_dir) begin
                        state <= 2'b01; // Resume walking right
                    end else begin
                        state <= 2'b00; // Resume walking left
                    end
                end
            end
            default: state <= 2'b00; // Invalid state, default to walk_left
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule