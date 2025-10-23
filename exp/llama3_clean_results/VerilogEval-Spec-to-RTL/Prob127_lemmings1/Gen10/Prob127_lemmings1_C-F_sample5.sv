module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
typedef enum logic [0:0] {LEFT, RIGHT} state_t;
reg state_t state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        if (state == LEFT) begin
            if (bump_left) begin
                state <= RIGHT;
            end
        end else begin
            if (bump_right) begin
                state <= LEFT;
            end
        end
    end
end

// Define outputs
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule