module TopModule (
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
reg [5:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // Walking Left
                if (!ground) begin
                    state <= 2;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end else if (dig) begin
                    state <= 3;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= 1;
                    walk_left <= 0;
                    walk_right <= 1;
                end
            end
            1: begin // Walking Right
                if (!ground) begin
                    state <= 2;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end else if (dig) begin
                    state <= 3;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= 0;
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end
            2: begin // Falling
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        if (state == 2) begin
                            if (digging) begin
                                state <= 0;
                                walk_left <= 1;
                                walk_right <= 0;
                            end else if (walk_left) begin
                                state <= 0;
                                walk_left <= 1;
                                walk_right <= 0;
                            end else begin
                                state <= 1;
                                walk_left <= 0;
                                walk_right <= 1;
                            end
                        end else begin
                            state <= 0;
                            walk_left <= 1;
                            walk_right <= 0;
                        end
                        aaah <= 0;
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            3: begin // Digging
                if (!ground) begin
                    state <= 2;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
            end
            4: begin // Splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule