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

    // State encoding:
    // bit[1]: 0=WALK, 1=FALL
    // bit[0]: 0=left, 1=right (only valid in WALK state)
    reg [1:0] state;

    // Next state logic
    wire falling = !ground;
    wire switch_dir = (state[0] ? bump_right : bump_left) && !falling;
    wire next_dir = state[1] ? state[0] : (switch_dir ? ~state[0] : state[0]);
    wire next_fall = falling || (state[1] && !ground);
    
    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= 2'b00;  // WALK left
        else
            state <= {next_fall, next_dir};
    end

    // Output logic
    assign walk_left = ~state[1] && ~state[0];
    assign walk_right = ~state[1] && state[0];
    assign aaah = state[1];

endmodule