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

reg [2:0] state;  // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [4:0] fall_count;  // counter for the number of clock cycles the Lemming has been falling
reg [2:0] prev_state;  // previous state before falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;  // walking left
        fall_count <= 0;
        prev_state <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin  // walking left
                if (ground == 0) begin
                    state <= 2;  // falling
                    prev_state <= 0;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig == 1) begin
                    state <= 3;  // digging
                    prev_state <= 0;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right == 1) begin
                    state <= 1;  // walking right
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            1: begin  // walking right
                if (ground == 0) begin
                    state <= 2;  // falling
                    prev_state <= 1;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig == 1) begin
                    state <= 3;  // digging
                    prev_state <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left == 1) begin
                    state <= 0;  // walking left
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            2: begin  // falling
                fall_count <= fall_count + 1;
                if (ground == 1) begin
                    if (fall_count > 20) begin
                        state <= 4;  // splattered
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        case (prev_state)
                            0: begin
                                state <= 0;  // walking left
                                walk_left <= 1;
                                walk_right <= 0;
                                aaah <= 0;
                                digging <= 0;
                            end
                            1: begin
                                state <= 1;  // walking right
                                walk_left <= 0;
                                walk_right <= 1;
                                aaah <= 0;
                                digging <= 0;
                            end
                            default: begin
                                state <= 0;  // walking left
                                walk_left <= 1;
                                walk_right <= 0;
                                aaah <= 0;
                                digging <= 0;
                            end
                        endcase
                    end
                end
            end
            3: begin  // digging
                if (ground == 0) begin
                    state <= 2;  // falling
                    prev_state <= 0;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig == 0) begin
                    case (prev_state)
                        0: begin
                            state <= 0;  // walking left
                            walk_left <= 1;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end
                        1: begin
                            state <= 1;  // walking right
                            walk_left <= 0;
                            walk_right <= 1;
                            aaah <= 0;
                            digging <= 0;
                        end
                        default: begin
                            state <= 0;  // walking left
                            walk_left <= 1;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end
                    endcase
                end
            end
            4: begin  // splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            default: begin
                state <= 0;  // walking left
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule