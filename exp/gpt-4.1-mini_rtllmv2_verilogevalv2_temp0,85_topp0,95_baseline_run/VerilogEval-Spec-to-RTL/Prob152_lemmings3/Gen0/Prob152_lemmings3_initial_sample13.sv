module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum logic [1:0] {
        WL = 2'b00, // walk left
        WR = 2'b01, // walk right
        FL = 2'b10, // falling, remembers direction left
        FG = 2'b11  // falling, remembers direction right
    } fall_state_t;

    typedef enum logic [1:0] {
        WLK = 2'b00, // walking left
        WRK = 2'b01, // walking right
        DG_L = 2'b10,// digging left
        DG_R = 2'b11 // digging right
    } state_t;

    state_t state, next_state;

    // To remember direction while falling, we separate fall states as FL and FG
    // and digging states as DG_L and DG_R.

    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WLK: begin // walking left on ground
                if (!ground) begin
                    // ground lost: fall keeping direction left
                    next_state = FL;
                end else if (dig) begin
                    // start digging left
                    next_state = DG_L;
                end else begin
                    // walking and ground=1
                    // bump causes direction switch
                    if (bump_left || bump_right) begin
                        // switch to walking right
                        next_state = WRK;
                    end
                end
            end

            WRK: begin // walking right on ground
                if (!ground) begin
                    // fall right
                    next_state = FG;
                end else if (dig) begin
                    // start digging right
                    next_state = DG_R;
                end else begin
                    if (bump_left || bump_right) begin
                        // switch to walking left
                        next_state = WLK;
                    end
                end
            end

            DG_L: begin // digging left on ground
                if (!ground) begin
                    // ground lost while digging: fall left
                    next_state = FL;
                end
                // bump and dig ignored while digging
            end

            DG_R: begin // digging right on ground
                if (!ground) begin
                    // fall right
                    next_state = FG;
                end
                // bump and dig ignored while digging
            end

            FL: begin // falling left
                if (ground) begin
                    // ground returned, go to walking left
                    next_state = WLK;
                end
                // bump and dig ignored while falling
            end

            FG: begin // falling right
                if (ground) begin
                    next_state = WRK;
                end
            end

            default: next_state = WLK;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WLK: begin
                walk_left = 1;
            end
            WRK: begin
                walk_right = 1;
            end
            DG_L: begin
                digging = 1;
                walk_left = 1;
            end
            DG_R: begin
                digging = 1;
                walk_right = 1;
            end
            FL: begin
                aaah = 1;
            end
            FG: begin
                aaah = 1;
            end
            default: begin
                // Should not occur, safe to assign walk_left=1
                walk_left = 1;
            end
        endcase
    end

endmodule