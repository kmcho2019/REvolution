module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

enum logic [0:1] {S_LEFT, S_RIGHT} state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= S_LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        S_LEFT: begin
            if(bump_left) begin
                next_state = S_RIGHT;
            end else if(bump_right) begin
                next_state = S_LEFT;
            end else begin
                next_state = S_LEFT;
            end
        end
        S_RIGHT: begin
            if(bump_left) begin
                next_state = S_RIGHT;
            end else if(bump_right) begin
                next_state = S_LEFT;
            end else begin
                next_state = S_RIGHT;
            end
        end
        default: next_state = S_LEFT;
    endcase
end

always_comb begin
    case(state)
        S_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        S_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule