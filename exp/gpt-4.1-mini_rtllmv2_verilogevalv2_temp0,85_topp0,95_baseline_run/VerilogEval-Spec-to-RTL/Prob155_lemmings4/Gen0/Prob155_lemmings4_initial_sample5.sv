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

    // State encoding: one-hot for clarity
    localparam WLK = 3'd0;  // Walking left
    localparam WRG = 3'd1;  // Walking right
    localparam FLL = 3'd2;  // Falling left
    localparam FLR = 3'd3;  // Falling right
    localparam DGL = 3'd4;  // Digging left
    localparam DGR = 3'd5;  // Digging right
    localparam SPL = 3'd6;  // Splattered

    reg [2:0] state, next_state;
    reg [4:0] fall_count, next_fall_count; // 5 bits to count >20 cycles

    wire bumped = bump_left | bump_right;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK;
            fall_count <= 0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Next state logic
    always @* begin
        // default values
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            SPL: begin
                // Once splattered, stay splattered forever until reset
                next_state = SPL;
                next_fall_count = 0;
            end

            WLK: begin
                if (~ground) begin
                    // Fall left if no ground
                    next_state = FLL;
                    next_fall_count = 1;
                end else if (dig) begin
                    // Start digging left
                    next_state = DGL;
                    next_fall_count = 0;
                end else if (bumped) begin
                    // Switch to walking right on bump
                    next_state = WRG;
                    next_fall_count = 0;
                end else begin
                    // Keep walking left
                    next_state = WLK;
                    next_fall_count = 0;
                end
            end

            WRG: begin
                if (~ground) begin
                    // Fall right if no ground
                    next_state = FLR;
                    next_fall_count = 1;
                end else if (dig) begin
                    // Start digging right
                    next_state = DGR;
                    next_fall_count = 0;
                end else if (bumped) begin
                    // Switch to walking left on bump
                    next_state = WLK;
                    next_fall_count = 0;
                end else begin
                    // Keep walking right
                    next_state = WRG;
                    next_fall_count = 0;
                end
            end

            FLL: begin
                if (~ground) begin
                    // Continue falling left
                    next_state = FLL;
                    if (fall_count < 31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = 31; // cap max count
                end else begin
                    // Landed on ground
                    if (fall_count > 20)
                        next_state = SPL;
                    else
                        next_state = WLK; // resume walking left
                    next_fall_count = 0;
                end
            end

            FLR: begin
                if (~ground) begin
                    // Continue falling right
                    next_state = FLR;
                    if (fall_count < 31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = 31;
                end else begin
                    // Landed on ground
                    if (fall_count > 20)
                        next_state = SPL;
                    else
                        next_state = WRG; // resume walking right
                    next_fall_count = 0;
                end
            end

            DGL: begin
                if (~ground) begin
                    // Digging ended by falling off the edge, start falling left
                    next_state = FLL;
                    next_fall_count = 1;
                end else begin
                    // Continue digging left
                    next_state = DGL;
                    next_fall_count = 0;
                end
            end

            DGR: begin
                if (~ground) begin
                    // Digging ended by falling off the edge, start falling right
                    next_state = FLR;
                    next_fall_count = 1;
                end else begin
                    // Continue digging right
                    next_state = DGR;
                    next_fall_count = 0;
                end
            end

            default: begin
                next_state = WLK;
                next_fall_count = 0;
            end
        endcase
    end

    // Output logic (Moore - depends only on state)
    always @* begin
        // default outputs all zero
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WLK: begin
                walk_left = 1;
            end
            WRG: begin
                walk_right = 1;
            end
            FLL: begin
                aaah = 1;
            end
            FLR: begin
                aaah = 1;
            end
            DGL: begin
                digging = 1;
                walk_left = 1;
            end
            DGR: begin
                digging = 1;
                walk_right = 1;
            end
            SPL: begin
                // All outputs remain zero
            end
        endcase
    end

endmodule