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

    // State encoding (2 bits):
    // bit1: falling (1) or walking (0)
    // bit0: direction (0=left, 1=right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    always @(*) begin
        next_state = state;  // default hold

        if (state[1] == 1'b0) begin
            // Walking state
            if (ground == 1'b0) begin
                // Start falling, preserve direction
                next_state = {1'b1, state[0]};
            end else if (bump_both) begin
                // Bump on both sides flips direction
                next_state = {1'b0, ~state[0]};
            end else if (bump_left) begin
                // Bump left walks right
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // Bump right walks left
                next_state = WALK_LEFT;
            end
            // else remain walking same direction
        end else begin
            // Falling state
            if (ground == 1'b1) begin
                // Ground reappeared, resume walking same direction
                next_state = {1'b0, state[0]};
            end
            // else remain falling same direction
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // reset state
        end else begin
            state <= next_state;
        end
    end

    assign aaah       = state[1];           // falling bit
    assign walk_left  = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & ( state[0]);

endmodule