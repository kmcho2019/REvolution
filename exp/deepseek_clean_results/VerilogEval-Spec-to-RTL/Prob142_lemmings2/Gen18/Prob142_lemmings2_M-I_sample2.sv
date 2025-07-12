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

    // State encoding: [1]=falling, [0]=direction (0=left, 1=right)
    reg [1:0] state;

    // Separate logic for falling state
    wire falling_next;
    assign falling_next = (!ground) ? 1'b1 : 1'b0;

    // Simplified direction logic
    wire direction_next;
    always @(*) begin
        if (areset)
            direction_next = 1'b0;
        else if (!state[1] && ground) begin
            case ({bump_left, bump_right})
                2'b10: direction_next = 1'b1;  // Bump left -> go right
                2'b01: direction_next = 1'b0;  // Bump right -> go left
                default: direction_next = state[0];  // No bump or both bumps
            endcase
        end
        else
            direction_next = state[0];
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= 2'b00;  // Walking left
        else
            state <= {falling_next, direction_next};
    end

    // Output assignments
    assign walk_left = !state[1] && !state[0];
    assign walk_right = !state[1] && state[0];
    assign aaah = state[1];

endmodule