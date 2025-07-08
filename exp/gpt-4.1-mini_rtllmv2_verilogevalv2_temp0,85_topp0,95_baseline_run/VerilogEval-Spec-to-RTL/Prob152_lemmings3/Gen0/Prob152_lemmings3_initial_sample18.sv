module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    typedef enum logic [1:0] {
        WL = 2'd0, // Walk Left
        WR = 2'd1, // Walk Right
        F  = 2'd2, // Falling
        D  = 2'd3  // Digging
    } state_t;

    state_t state, next_state;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default outputs
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;
        next_state = state;

        case(state)
            WL: begin
                // Outputs for walking left
                walk_left = 1'b1;
                // Priority: fall > dig > switch direction
                if (ground == 1'b0) begin
                    next_state = F;
                end else if (dig) begin
                    next_state = D;
                end else if (bump_left || bump_right) begin
                    // switch direction to walk right
                    next_state = WR;
                end else begin
                    next_state = WL;
                end
            end
            WR: begin
                // Outputs for walking right
                walk_right = 1'b1;
                if (ground == 1'b0) begin
                    next_state = F;
                end else if (dig) begin
                    next_state = D;
                end else if (bump_left || bump_right) begin
                    // switch direction to walk left
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end
            F: begin
                // Falling
                aaah = 1'b1;
                // Remain falling if ground=0
                if (ground == 1'b1) begin
                    // Resume walking in previous direction
                    // We must remember direction before falling
                    // To do this, store direction on falling entry
                    // So here, we stay falling if ground==0,
                    // but if ground=1, go to previous walking state.
                    // We'll store direction in a register.
                    if (state_dir == 0)
                        next_state = WL;
                    else
                        next_state = WR;
                end else begin
                    next_state = F;
                end
            end
            D: begin
                // Digging in current direction
                digging = 1'b1;
                if (ground == 1'b0) begin
                    // No ground, start falling
                    next_state = F;
                end else begin
                    // Continue digging
                    next_state = D;
                end
            end
            default: begin
                next_state = WL;
            end
        endcase
    end

    // Need to remember walking direction for falling recovery.
    // We'll store direction separately.
    // 0 = left, 1 = right
    reg state_dir;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            state_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update direction when walking or digging only
            case(next_state)
                WL: state_dir <= 1'b0;
                WR: state_dir <= 1'b1;
                D:  state_dir <= state_dir; // keep direction during digging
                F:  state_dir <= state_dir; // keep direction during falling
                default: state_dir <= 1'b0;
            endcase
        end
    end

endmodule