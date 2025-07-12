module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
typedef enum {LEFT, RIGHT} state_t;

reg state;

// Define sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        case (state)
            LEFT: begin
                if (bump_left || (bump_left && bump_right)) begin
                    state <= RIGHT;
                end
            end
            RIGHT: begin
                if (bump_right || (bump_left && bump_right)) begin
                    state <= LEFT;
                end
            end
        endcase
    end
end

// Define outputs
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule