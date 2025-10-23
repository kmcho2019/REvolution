module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
reg [0:0] state; // 0: walking left, 1: walking right
reg [0:0] next_state;

// Define the state transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to walking left
    end else begin
        state <= next_state;
    end
end

// Define the next state logic
always @(*) begin
    case (state)
        0: begin // Walking left
            if (bump_left) begin
                next_state = 1; // Switch to walking right
            end else begin
                next_state = 0; // Keep walking left
            end
        end
        1: begin // Walking right
            if (bump_right) begin
                next_state = 0; // Switch to walking left
            end else begin
                next_state = 1; // Keep walking right
            end
        end
        default: next_state = 0; // Default to walking left
    endcase

    // If bumped on both sides, still switch directions
    if (bump_left && bump_right) begin
        next_state = ~state;
    end
end

// Define the output logic
assign walk_left = (state == 0);
assign walk_right = (state == 1);

endmodule