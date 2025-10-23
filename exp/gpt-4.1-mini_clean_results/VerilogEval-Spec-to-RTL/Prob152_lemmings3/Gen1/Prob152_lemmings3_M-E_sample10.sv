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

    // State encoding:
    // bit 0: direction (0=left,1=right)
    // bit 2: mode (0=walking,1=falling or digging)
    // bit 1: submode (0=walking or falling, 1=digging)
    // Modes:
    // 000 = walking left
    // 001 = walking right
    // 100 = falling left
    // 101 = falling right
    // 110 = digging left
    // 111 = digging right

    reg [2:0] state, next_state;

    // Helper signals for current state components
    wire walking_mode   = (state[2:1] == 2'b00); // mode=0 submode=0
    wire falling_mode   = (state[2:1] == 2'b10); // mode=1 submode=0
    wire digging_mode   = (state[2:1] == 2'b11); // mode=1 submode=1
    wire direction_left = (state[0] == 1'b0);
    wire direction_right= (state[0] == 1'b1);

    // Compute next state
    always @(*) begin
        next_state = state; // default hold

        if (areset) begin
            next_state = 3'b000; // walking left
        end else begin
            case (state[2:1]) // mode, submode
                2'b00: begin // walking mode
                    if (!ground) begin
                        // Fall has priority
                        // Falling mode: mode=1, submode=0, keep direction
                        next_state = {1'b1,1'b0,state[0]};
                    end else if (dig) begin
                        // Start digging only if on ground and walking
                        // mode=1, submode=1, keep direction
                        next_state = {1'b1,1'b1,state[0]};
                    end else if (bump_left || bump_right) begin
                        // Switch walking direction on bump
                        // direction flips, mode stays walking (00)
                        next_state = {2'b00, ~state[0]};
                    end
                    else begin
                        // Remain walking same direction
                        next_state = state;
                    end
                end

                2'b10: begin // falling mode (falling)
                    if (ground) begin
                        // On ground, return to walking mode (00), same direction
                        next_state = {2'b00, state[0]};
                    end else begin
                        // Stay falling same direction
                        next_state = state;
                    end
                end

                2'b11: begin // digging mode
                    if (!ground) begin
                        // Ground lost while digging -> fall mode with same direction
                        next_state = {1'b1,1'b0,state[0]}; // falling mode, direction retained
                    end else begin
                        // Continue digging
                        next_state = state;
                    end
                end

                default: begin
                    // For submode=01 or other not used states, default to walking left
                    next_state = 3'b000;
                end
            endcase
        end
    end

    // Sequential logic to update state on clock edge or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000; // walking left initial state
        end else begin
            state <= next_state;
        end
    end

    // Output combinational logic (Moore machine)
    always @(*) begin
        // Default all outputs low
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case (state[2:1])
            2'b00: begin // walking mode
                if (direction_left)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
                // no aaah or digging
            end

            2'b10: begin // falling mode
                aaah = 1'b1;
                // no walking or digging outputs
            end

            2'b11: begin // digging mode
                digging = 1'b1;
                if (direction_left)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end

            default: begin
                // no outputs asserted for unused states
            end
        endcase
    end

endmodule