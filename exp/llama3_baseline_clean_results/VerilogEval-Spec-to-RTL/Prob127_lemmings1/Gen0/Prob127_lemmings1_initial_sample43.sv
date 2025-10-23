module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    output          walk_left,
    output          walk_right
);

// Define the states
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        default: begin
            next_state = LEFT;
        end
    endcase

    if (bump_left && bump_right) begin
        case (state)
            LEFT: begin
                next_state = RIGHT;
            end
            RIGHT: begin
                next_state = LEFT;
            end
            default: begin
                next_state = LEFT;
            end
        endcase
    end
end

// Output logic
always_comb begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule