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
    wire should_switch = (state[0] ? bump_right : bump_left) && !state[1];
    wire next_dir = state[1] ? state[0] : (should_switch ? ~state[0] : state[0]);
    wire next_fall = falling || (state[1] && !ground);

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // WALK left
        end
        else begin
            state <= {next_fall, next_dir};
        end
    end

    // Output logic
    assign walk_left = ~state[1] && ~state[0];
    assign walk_right = ~state[1] && state[0];
    assign aaah = state[1];

endmodule