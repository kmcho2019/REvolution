module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

// Enumerate states
enum logic [0:0] {LEFT, RIGHT} state;

// Use a single always block for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        case (state)
            LEFT: state <= (bump_left || bump_right) ? RIGHT : LEFT;
            RIGHT: state <= (bump_left || bump_right) ? LEFT : RIGHT;
        endcase
    end
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule