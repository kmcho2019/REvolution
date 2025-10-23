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

    // State encoding: 3 bits to cover all 6 states
    localparam
        WLK_L = 3'b000, // walking left
        WLK_R = 3'b001, // walking right
        FAL_L = 3'b010, // falling left
        FAL_R = 3'b011, // falling right
        DIG_L = 3'b100, // digging left
        DIG_R = 3'b101; // digging right

    reg [2:0] state, next_state;

    // Synchronous state register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WLK_L;
        else
            state <= next_state;
    end

    // Next state logic: Moore FSM with priority fall > dig > bump
    always @(*) begin
        // Default next state is current state (no change)
        next_state = state;

        case(state)
            // Walking Left
            WLK_L: begin
                if (!ground) // fall has highest priority
                    next_state = FAL_L;
                else if (dig) // dig if ground present and dig asserted
                    next_state = DIG_L;
                else if (bump_left || bump_right) // bump changes direction
                    next_state = WLK_R;
                else
                    next_state = WLK_L;
            end

            // Walking Right
            WLK_R: begin
                if (!ground)
                    next_state = FAL_R;
                else if (dig)
                    next_state = DIG_R;
                else if (bump_left || bump_right)
                    next_state = WLK_L;
                else
                    next_state = WLK_R;
            end

            // Falling Left
            FAL_L: begin
                if (ground)
                    next_state = WLK_L; // resume walking left when ground returns
                else
                    next_state = FAL_L; // remain falling
            end

            // Falling Right
            FAL_R: begin
                if (ground)
                    next_state = WLK_R;
                else
                    next_state = FAL_R;
            end

            // Digging Left
            DIG_L: begin
                if (!ground) // dig ended, fall
                    next_state = FAL_L;
                else
                    next_state = DIG_L; // continue digging
            end

            // Digging Right
            DIG_R: begin
                if (!ground)
                    next_state = FAL_R;
                else
                    next_state = DIG_R;
            end

            default: next_state = WLK_L; // safe default on unknown state
        endcase
    end

    // Output logic: Moore outputs depend on state
    assign walk_left  = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign aaah       = (state == FAL_L) || (state == FAL_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule