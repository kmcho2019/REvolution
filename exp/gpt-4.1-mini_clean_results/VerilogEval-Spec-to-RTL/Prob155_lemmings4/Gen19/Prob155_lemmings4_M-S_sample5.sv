module TopModule (
    input  logic clk,
    input  logic areset,       // async posedge reset
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    typedef enum logic [3:0] {
        WALK_L = 4'd0,
        WALK_R = 4'd1,
        DIG_L  = 4'd2,
        DIG_R  = 4'd3,
        FALL_L = 4'd4,
        FALL_R = 4'd5,
        SPLAT  = 4'd6
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_count, next_fall_count;

    // Async reset and sequential state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        next_fall_count = 5'd0;

        // Helper signals
        logic bump = bump_left | bump_right;
        logic bump_both = bump_left & bump_right;
        logic walk_dir; // 0=left,1=right for walk/dig/fall states

        // Extract direction for walking/digging/falling states
        case (state)
            WALK_L, DIG_L, FALL_L: walk_dir = 1'b0;
            WALK_R, DIG_R, FALL_R: walk_dir = 1'b1;
            default: walk_dir = 1'b0; // for SPLAT (irrelevant)
        endcase

        if (state == SPLAT) begin
            next_state = SPLAT;
            next_fall_count = 5'd0;
        end else if ((state == FALL_L) || (state == FALL_R)) begin
            if (ground) begin
                // Landed after fall
                if (fall_count > 5'd20)
                    next_state = SPLAT;
                else
                    next_state = walk_dir ? WALK_R : WALK_L;
                next_fall_count = 5'd0;
            end else begin
                // Continue falling
                next_state = walk_dir ? FALL_R : FALL_L;
                next_fall_count = fall_count + 5'd1;
            end
        end else if (state == DIG_L || state == DIG_R) begin
            if (!ground) begin
                // Start falling from dig
                next_state = walk_dir ? FALL_R : FALL_L;
                next_fall_count = 5'd1;
            end else begin
                // Continue digging on ground
                next_state = walk_dir ? DIG_R : DIG_L;
                next_fall_count = 5'd0;
            end
        end else begin
            // WALK states
            // Check fall first
            if (!ground) begin
                next_state = walk_dir ? FALL_R : FALL_L;
                next_fall_count = 5'd1;
            end else if (dig) begin
                next_state = walk_dir ? DIG_R : DIG_L;
                next_fall_count = 5'd0;
            end else if (bump) begin
                // Switch direction according to bump logic
                if (bump_both) begin
                    next_state = walk_dir ? WALK_L : WALK_R;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
                next_fall_count = 5'd0;
            end else begin
                next_state = walk_dir ? WALK_R : WALK_L;
                next_fall_count = 5'd0;
            end
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule