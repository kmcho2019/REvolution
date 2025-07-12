module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // state variable (0: walking left, 1: walking right)
reg [0:0] next_state; // next state variable

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        0: begin // walking left
            if (bump_left) begin
                next_state = 1; // switch to walking right
            end else begin
                next_state = 0; // stay walking left
            end
        end
        1: begin // walking right
            if (bump_right) begin
                next_state = 0; // switch to walking left
            end else begin
                next_state = 1; // stay walking right
            end
        end
        default: begin
            next_state = 0; // default to walking left
        end
    endcase

    // Handle bump on both sides
    if (bump_left && bump_right) begin
        next_state = ~state; // switch directions
    end
end

// Output logic
assign walk_left = (state == 0);
assign walk_right = (state == 1);

endmodule