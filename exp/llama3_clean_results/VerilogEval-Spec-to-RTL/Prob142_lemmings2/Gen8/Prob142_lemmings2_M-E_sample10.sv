module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [3:0] state; // one-hot encoding for the four states
reg [3:0] next_state;
reg direction; // 1 for walking right, 0 for walking left
reg next_direction;

// Combinational logic to determine the next state and direction
always @(*) begin
    next_state = state;
    next_direction = direction;

    casez (state)
        4'b0001: // walking left
            begin
                if (~ground) begin
                    next_state = 4'b0010; // falling left
                end else if (bump_left) begin
                    next_state = 4'b0100; // walking right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end
            end
        4'b0100: // walking right
            begin
                if (~ground) begin
                    next_state = 4'b1000; // falling right
                end else if (bump_right) begin
                    next_state = 4'b0001; // walking left
                    next_direction = 1'b0;
                end else if (bump_left) begin
                    // do nothing, keep walking right
                end
            end
        4'b0010: // falling left
            begin
                if (ground) begin
                    next_state = 4'b0001; // walking left
                end
            end
        4'b1000: // falling right
            begin
                if (ground) begin
                    next_state = 4'b0100; // walking right
                end
            end
        default: next_state = 4'b0001; // default to walking left
    endcase
end

// Sequential logic to update the state and direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001; // reset to walking left
        direction <= 1'b0;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Output logic
assign walk_left = (state == 4'b0001 && direction == 1'b0)? 1'b1 : 1'b0;
assign walk_right = (state == 4'b0100 && direction == 1'b1)? 1'b1 : 1'b0;
assign aaah = (state == 4'b0010 || state == 4'b1000)? 1'b1 : 1'b0;

endmodule