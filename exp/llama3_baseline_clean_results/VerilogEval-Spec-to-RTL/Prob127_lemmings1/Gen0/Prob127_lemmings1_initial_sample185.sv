module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
localparam WALK_LEFT = 1'b0;
localparam WALK_RIGHT = 1'b1;

reg state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left || bump_right) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_left || bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        default: next_state <= WALK_LEFT;
    endcase
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
        default: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
    endcase
end

endmodule