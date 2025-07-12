module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: 
    // [2] - FALL
    // [1] - WALK_RIGHT
    // [0] - WALK_LEFT
    // DIG is a condition within WALK states
    reg [2:0] state;
    reg is_digging;

    // Direction change detection
    wire change_to_right = bump_left & ~bump_right;
    wire change_to_left = bump_right & ~bump_left;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 3'b001; // WALK left
            is_digging <= 1'b0;
        end else begin
            if (state[2]) begin // FALL
                if (ground) state <= {1'b0, state[1:0]}; // Return to previous WALK state
            end else begin // WALK
                if (~ground) begin
                    state <= 3'b100; // FALL
                    is_digging <= 1'b0;
                end else if (dig) begin
                    is_digging <= 1'b1;
                end else if (~is_digging) begin
                    // Handle direction changes
                    if (change_to_right) state <= 3'b010;
                    else if (change_to_left) state <= 3'b001;
                end
            end
        end
    end

    // Simplified output logic
    assign walk_left = state[0] & ~is_digging;
    assign walk_right = state[1] & ~is_digging;
    assign aaah = state[2];
    assign digging = (state[1] | state[0]) & is_digging;

endmodule