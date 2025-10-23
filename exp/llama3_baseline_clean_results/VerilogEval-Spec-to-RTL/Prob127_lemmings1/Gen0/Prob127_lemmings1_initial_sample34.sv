module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 0: walking left, 1: walking right
reg [0:0] next_state;

// State machine output
assign walk_left = (state == 0);
assign walk_right = (state == 1);

// Next state logic
always @(state or bump_left or bump_right) begin
    case (state)
        0: begin // walking left
            if (bump_left == 1) begin
                next_state = 1; // walk right
            end else begin
                next_state = 0; // stay walking left
            end
        end
        1: begin // walking right
            if (bump_right == 1) begin
                next_state = 0; // walk left
            end else begin
                next_state = 1; // stay walking right
            end
        end
    endcase
end

// If both bump_left and bump_right are 1, switch directions
always @(bump_left or bump_right) begin
    if (bump_left == 1 && bump_right == 1) begin
        if (state == 0) begin
            next_state = 1;
        end else begin
            next_state = 0;
        end
    end
end

// State machine sequential logic
always @(posedge clk or posedge areset) begin
    if (areset == 1) begin
        state <= 0; // reset to walking left
    end else begin
        if (bump_left == 1) begin
            state <= 1; // walk right
        end else if (bump_right == 1) begin
            state <= 0; // walk left
        end else if (bump_left == 1 && bump_right == 1) begin
            if (state == 0) begin
                state <= 1; // switch to walking right
            end else begin
                state <= 0; // switch to walking left
            end
        end else begin
            state <= state; // stay in the same state
        end
    end
end

endmodule