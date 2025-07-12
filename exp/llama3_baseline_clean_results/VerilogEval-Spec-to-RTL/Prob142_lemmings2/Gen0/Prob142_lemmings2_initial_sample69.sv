module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 00: walking left, 01: walking right, 10: falling
reg [1:0] prev_state; // to keep track of the previous state before falling

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        prev_state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (ground == 0) begin
                    state <= 2'b10; // fall
                    prev_state <= 2'b00;
                end else if (bump_left == 1) begin
                    state <= 2'b01; // turn right
                end else if (bump_right == 1) begin
                    state <= 2'b01; // turn right
                end
            end
            2'b01: begin // walking right
                if (ground == 0) begin
                    state <= 2'b10; // fall
                    prev_state <= 2'b01;
                end else if (bump_right == 1) begin
                    state <= 2'b00; // turn left
                end else if (bump_left == 1) begin
                    state <= 2'b00; // turn left
                end
            end
            2'b10: begin // falling
                if (ground == 1) begin
                    state <= prev_state; // resume walking
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        2'b00: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        2'b01: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2'b10: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule