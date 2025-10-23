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

    // State encoding:
    // bit1 = falling (1) / walking (0)
    // bit0 = direction: 0=left, 1=right
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    wire falling   = state[1];
    wire direction = state[0];
    wire bumped    = bump_left | bump_right;

    // Combinational next state logic using simplified bump detection
    always @(*) begin
        next_state = state; // default: hold current state

        if (!falling) begin
            // Walking and on ground or not
            if (!ground) begin
                // Start falling with same direction
                next_state = {1'b1, direction};
            end else if (bumped) begin
                // Bumped (left or right or both) when walking and ground present
                // Flip direction regardless of which bump side
                next_state = {1'b0, ~direction};
            end
            // else remain walking same direction
        end else begin
            // Falling state
            if (ground) begin
                // Land and resume walking with same direction
                next_state = {1'b0, direction};
            end
            // else continue falling ignoring bumps
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // Reset to walk_left
        else
            state <= next_state;
    end

    // Moore outputs directly decoded from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule