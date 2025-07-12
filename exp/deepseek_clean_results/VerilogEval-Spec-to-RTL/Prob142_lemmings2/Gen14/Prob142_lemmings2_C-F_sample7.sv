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

    reg state;      // 0=WALK, 1=FALL
    reg direction;  // 0=left, 1=right

    // Next state computation
    wire falling = !ground;
    wire walking = !state;
    wire switch_dir = (direction ? bump_right : bump_left) & walking;
    wire next_dir = state ? direction : (switch_dir ? !direction : direction);
    wire next_state = falling | (state & !ground);

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;
            direction <= 0;
        end else begin
            state <= next_state;
            direction <= next_dir;
        end
    end

    // Optimized output logic with shared terms
    wire not_falling = ~state;
    assign walk_left = not_falling & ~direction;
    assign walk_right = not_falling & direction;
    assign aaah = state;

endmodule