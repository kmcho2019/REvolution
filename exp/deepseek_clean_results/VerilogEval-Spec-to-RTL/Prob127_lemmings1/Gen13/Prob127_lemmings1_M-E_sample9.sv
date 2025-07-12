module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State register [preferred_dir, current_dir]
    reg [1:0] state;

    // Next state logic
    wire current_dir = state[0];
    wire preferred_dir = state[1];
    wire bump_on_current = (current_dir ? bump_right : bump_left);
    wire bump_on_opposite = (current_dir ? bump_left : bump_right);

    wire [1:0] next_state;
    assign next_state = bump_on_current ? {~preferred_dir, ~current_dir} :
                        bump_on_opposite ? {preferred_dir, current_dir} :
                        state;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // Prefer left, walk left
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = ~state[0];
    assign walk_right = state[0];

endmodule