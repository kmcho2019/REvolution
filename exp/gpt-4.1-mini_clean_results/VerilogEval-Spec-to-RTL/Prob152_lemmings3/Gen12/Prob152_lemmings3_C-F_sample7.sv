module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding (2 bits)
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    // State register: [2:1] = mode, [0] = direction (0=left,1=right)
    reg [2:0] state, next_state;
    wire [1:0] mode = state[2:1];
    wire dir = state[0];

    // Combined bump signal when walking on ground
    wire bump = bump_left | bump_right;

    always @(*) begin
        next_state = state; // default hold state

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Falling takes highest priority
                    next_state = {MODE_FALL, dir};
                end else if (dig) begin
                    // Start digging if dig=1 while walking on ground
                    next_state = {MODE_DIG, dir};
                end else if (bump) begin
                    // Switch direction on any bump while walking on ground
                    // Bump both or either side toggles direction
                    next_state = {MODE_WALK, ~dir};
                end
                // else remain walking same direction
            end

            MODE_FALL: begin
                if (ground) begin
                    // Land and resume walking same direction
                    next_state = {MODE_WALK, dir};
                end
                // else remain falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Start falling when ground disappears while digging
                    next_state = {MODE_FALL, dir};
                end
                // else remain digging
            end

            default: begin
                // Defensive reset to walk left for unexpected states
                next_state = {MODE_WALK, 1'b0};
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        else
            state <= next_state;
    end

    // Moore outputs decoded from state
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule