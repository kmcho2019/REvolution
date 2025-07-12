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
reg prev_state;

// Define sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
        prev_state <= LEFT;
    end else begin
        case (state)
            LEFT: begin
                if (bump_left) begin
                    state <= RIGHT;
                end
            end
            RIGHT: begin
                if (bump_right) begin
                    state <= LEFT;
                end
            end
        endcase
        prev_state <= state;
    end
end

// Define outputs with minimal transition
always @(posedge clk) begin
    if (state != prev_state) begin
        case (state)
            LEFT: begin
                walk_left <= 1;
                walk_right <= 0;
            end
            RIGHT: begin
                walk_left <= 0;
                walk_right <= 1;
            end
        endcase
    end
end

endmodule