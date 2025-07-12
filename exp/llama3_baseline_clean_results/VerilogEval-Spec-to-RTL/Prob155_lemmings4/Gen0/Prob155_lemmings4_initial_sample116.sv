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

reg [2:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [5:0] fall_count; // count the number of clock cycles the Lemming has been falling
reg walk_dir; // 0: walking left, 1: walking right

// state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        walk_dir <= 0;
        fall_count <= 0;
    end
    else begin
        case (state)
            0: // walking left
                if (~ground) begin
                    state <= 2;
                    fall_count <= 1;
                end
                else if (dig && ~bump_left && ~bump_right) begin
                    state <= 3;
                end
                else if (bump_left) begin
                    walk_dir <= 1;
                    state <= 1;
                end
                else if (bump_right) begin
                    walk_dir <= 0;
                end
            1: // walking right
                if (~ground) begin
                    state <= 2;
                    fall_count <= 1;
                end
                else if (dig && ~bump_left && ~bump_right) begin
                    state <= 3;
                end
                else if (bump_right) begin
                    walk_dir <= 0;
                    state <= 0;
                end
                else if (bump_left) begin
                    walk_dir <= 1;
                end
            2: // falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4;
                    end
                    else begin
                        state <= walk_dir ? 1 : 0;
                    end
                    fall_count <= 0;
                end
            3: // digging
                if (~ground) begin
                    state <= 2;
                    fall_count <= 1;
                end
            4: // splattered
                // do nothing
        endcase
    end
end

// output logic
always @(posedge clk) begin
    case (state)
        0: begin // walking left
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        1: begin // walking right
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
            digging <= 0;
        end
        2: begin // falling
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        3: begin // digging
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        4: begin // splattered
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule