module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding using named localparams for clarity
    localparam WALK_LEFT  = 2'b00; // falling=0, direction=0
    localparam WALK_RIGHT = 2'b01; // falling=0, direction=1
    localparam FALL_LEFT  = 2'b10; // falling=1, direction=0
    localparam FALL_RIGHT = 2'b11; // falling=1, direction=1

    reg [1:0] state, next_state;

    // Extract state bits for clarity
    wire falling   = state[1];
    wire direction = state[0];

    // Combinational next-state logic for clarity and safe next_state assignment
    always @(*) begin
        next_state = state; // default hold

        if (falling) begin
            // While falling, ignore bumps; only respond to ground reappearance
            if (ground)
                next_state = {1'b0, direction}; // land, resume walking same direction
        end else begin
            // Walking
            if (!ground) begin
                // Ground lost: start falling, preserve direction
                next_state = {1'b1, direction};
            end else begin
                // On ground and walking, bumps can flip or set direction
                if (bump_left && bump_right) begin
                    next_state = {1'b0, ~direction}; // both bumps flip direction
                end else if (bump_left) begin
                    next_state = {1'b0, 1'b1}; // bump left -> walk right
                end else if (bump_right) begin
                    next_state = {1'b0, 1'b0}; // bump right -> walk left
                end
                // else hold current walking direction
            end
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs decoded directly from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule