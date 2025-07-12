module TopModule (
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

    // One-hot state encoding
    parameter S_WALK_L = 0;
    parameter S_WALK_R = 1;
    parameter S_DIG_L = 2;
    parameter S_DIG_R = 3;
    parameter S_FALL_L = 4;
    parameter S_FALL_R = 5;
    parameter S_SPLAT = 6;

    reg [6:0] state;
    reg [4:0] fall_counter;

    // Next state logic
    wire [6:0] next_state;
    assign next_state = 
        (state[S_SPLAT]) ? state : // Stay in SPLAT once reached
        (!ground) ? ( // Falling has highest priority
            state[S_WALK_L] || state[S_DIG_L] ? (1 << S_FALL_L) :
            state[S_WALK_R] || state[S_DIG_R] ? (1 << S_FALL_R) :
            state[S_FALL_L] ? (1 << S_FALL_L) :
            state[S_FALL_R] ? (1 << S_FALL_R) :
            (1 << S_WALK_L) // Default to walk left if undefined
        ) :
        (dig && (state[S_WALK_L] || state[S_WALK_R])) ? ( // Digging has middle priority
            state[S_WALK_L] ? (1 << S_DIG_L) : (1 << S_DIG_R)
        ) :
        (state[S_WALK_L] && (bump_left || bump_right)) ? (1 << S_WALK_R) : // Bumping
        (state[S_WALK_R] && (bump_left || bump_right)) ? (1 << S_WALK_L) :
        (state[S_FALL_L] || state[S_FALL_R]) ? ( // Landing from fall
            (fall_counter > 20) ? (1 << S_SPLAT) :
            state[S_FALL_L] ? (1 << S_WALK_L) : (1 << S_WALK_R)
        ) :
        state; // Default case - stay in current state

    // Fall counter logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else begin
            if (state[S_FALL_L] || state[S_FALL_R]) begin
                if (!ground) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    fall_counter <= 0;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= (1 << S_WALK_L);
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = state[S_WALK_L];
    assign walk_right = state[S_WALK_R];
    assign aaah = state[S_FALL_L] || state[S_FALL_R];
    assign digging = state[S_DIG_L] || state[S_DIG_R];

endmodule