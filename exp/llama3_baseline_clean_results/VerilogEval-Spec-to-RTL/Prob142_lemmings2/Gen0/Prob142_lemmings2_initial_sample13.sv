module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
reg [1:0] state; // 0: walking left, 1: walking right, 2: falling left, 3: falling right
reg prev_walk_dir; // 0: left, 1: right

// Initialize the state and previous walking direction
initial begin
    state = 0; // walking left
    prev_walk_dir = 0; // left
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = 0; // walking left
        prev_walk_dir = 0; // left
    end else begin
        case (state)
            0: // walking left
                if (bump_right) begin
                    state = 1; // walking right
                end else if (!ground) begin
                    state = 2; // falling left
                end
            1: // walking right
                if (bump_left) begin
                    state = 0; // walking left
                end else if (!ground) begin
                    state = 3; // falling right
                end
            2: // falling left
                if (ground) begin
                    state = 0; // walking left
                end
            3: // falling right
                if (ground) begin
                    state = 1; // walking right
                end
        endcase
    end
end

// Determine the outputs based on the state
always @(*) begin
    walk_left = (state == 0); // walking left
    walk_right = (state == 1); // walking right
    aaah = (state == 2 || state == 3); // falling
end

endmodule