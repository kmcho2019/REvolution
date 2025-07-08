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
    typedef enum logic [2:0] {
        WL = 3'b000, // walk left
        WR = 3'b001, // walk right
        DL = 3'b010, // digging left
        DR = 3'b011, // digging right
        FL = 3'b100, // falling left
        FR = 3'b101, // falling right
        SPLAT = 3'b110 // splattered
    } state_t;

    state_t state, next_state;

    // Fall counter
    reg [4:0] fall_count; // enough to count to >20

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            if (state == FL || state == FR) begin
                // Increment fall counter while falling
                if (next_state == FL || next_state == FR)
                    fall_count <= fall_count + 5'd1;
                else
                    fall_count <= 5'd0; // reset when leaving falling state
            end else begin
                fall_count <= 5'd0;
            end
        end
    end

    // Next state logic (Moore)
    always @(*) begin
        next_state = state;
        case(state)
            WL: begin
                // walking left on ground, not digging
                // precedence: fall > dig > bump
                if (ground == 0) begin
                    // start falling left
                    next_state = FL;
                end else if (dig == 1) begin
                    // start digging left
                    next_state = DL;
                end else begin
                    // bumps cause direction switch if bump_left or bump_right or both
                    // Bump left or right or both causes direction switch
                    if ((bump_left | bump_right) != 0)
                        next_state = WR;
                    else
                        next_state = WL;
                end
            end
            WR: begin
                // walking right on ground, not digging
                if (ground == 0) begin
                    // start falling right
                    next_state = FR;
                end else if (dig == 1) begin
                    // start digging right
                    next_state = DR;
                end else begin
                    if ((bump_left | bump_right) != 0)
                        next_state = WL;
                    else
                        next_state = WR;
                end
            end
            DL: begin
                // digging left on ground
                // If ground disappears, fall left
                if (ground == 0) begin
                    next_state = FL;
                end else begin
                    // continue digging, bump and dig have no effect here
                    next_state = DL;
                end
            end
            DR: begin
                // digging right on ground
                if (ground == 0) begin
                    next_state = FR;
                end else begin
                    next_state = DR;
                end
            end
            FL: begin
                // falling left, bumps and dig ignored
                if (ground == 1) begin
                    // landed, check fall_count > 20 for splatter
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WL; // resume walking left
                end else begin
                    next_state = FL;
                end
            end
            FR: begin
                // falling right
                if (ground == 1) begin
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WR; // resume walking right
                end else begin
                    next_state = FR;
                end
            end
            SPLAT: begin
                // splattered - forever off until reset
                next_state = SPLAT;
            end
            default: next_state = WL;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WL: walk_left = 1'b1;
            WR: walk_right = 1'b1;
            DL: digging = 1'b1;
            DR: digging = 1'b1;
            FL: aaah = 1'b1;
            FR: aaah = 1'b1;
            SPLAT: begin
                // all outputs zero
            end
        endcase
    end

endmodule