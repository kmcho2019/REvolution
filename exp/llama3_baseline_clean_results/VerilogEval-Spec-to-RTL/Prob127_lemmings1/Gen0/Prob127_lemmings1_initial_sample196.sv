module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 0: walking left, 1: walking right
reg [0:0] next_state;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end

always @ (*) begin
    case (state)
        0: begin
            if (bump_left) begin
                next_state = 1;
            end else begin
                next_state = 0;
            end
        end
        1: begin
            if (bump_right) begin
                next_state = 0;
            end else begin
                next_state = 1;
            end
        end
        default: begin
            next_state = 0;
        end
    endcase

    if (bump_left && bump_right) begin
        next_state = ~state;
    end
end

always @ (*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
        end
    endcase
end

endmodule