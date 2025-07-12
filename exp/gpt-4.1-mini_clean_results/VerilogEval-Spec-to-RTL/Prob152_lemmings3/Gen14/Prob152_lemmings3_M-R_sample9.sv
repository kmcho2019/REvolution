module TopModule(
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

    // Mode encoding
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    reg [2:0] state;       // {mode[1:0], direction}
    reg [2:0] next_state;

    wire [1:0] mode = state[2:1];
    wire dir = state[0];
    wire bump = bump_left | bump_right;

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default: stay same

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Start falling if ground lost
                    next_state = {MODE_FALL, dir};
                end else if (dig) begin
                    // Start digging if commanded while walking on ground
                    next_state = {MODE_DIG, dir};
                end else if (bump) begin
                    // Switch direction on any bump while walking
                    // Direction toggled if any bump left or right (or both)
                    next_state = {MODE_WALK, ~dir};
                end
                // else remain walking same direction
            end

            MODE_FALL: begin
                if (ground) begin
                    // Resume walking in same direction when ground returns
                    next_state = {MODE_WALK, dir};
                end
                // else remain falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Start falling when ground disappears while digging
                    next_state = {MODE_FALL, dir};
                end
                // else continue digging
            end

            default: begin
                // Defensive fallback: reset to walking left
                next_state = {MODE_WALK, 1'b0};
            end
        endcase
    end

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs from current state
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule