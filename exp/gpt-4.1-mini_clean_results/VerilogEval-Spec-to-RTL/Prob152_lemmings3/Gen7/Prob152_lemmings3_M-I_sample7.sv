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

    // One-hot encoded FSM states (6 states: walking left/right, falling left/right, digging left/right)
    localparam WL = 6'b000001; // Walking Left
    localparam WR = 6'b000010; // Walking Right
    localparam FL = 6'b000100; // Falling Left
    localparam FR = 6'b001000; // Falling Right
    localparam DL = 6'b010000; // Digging Left
    localparam DR = 6'b100000; // Digging Right

    reg [5:0] state, next_state;

    // Register to hold previous ground for edge detection
    reg prev_ground;

    // Asynchronous reset, sync state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL; // Reset to walking left
            prev_ground <= 1'b1; // Assume starting on ground
        end else begin
            state <= next_state;
            prev_ground <= ground;
        end
    end

    // Detect ground falling edge (ground from 1 to 0)
    wire ground_falling_edge = (prev_ground == 1'b1) && (ground == 1'b0);

    // Detect ground rising edge (ground from 0 to 1)
    wire ground_rising_edge = (prev_ground == 1'b0) && (ground == 1'b1);

    // Helper signals
    wire walking = (state == WL) || (state == WR);
    wire falling = (state == FL) || (state == FR);
    wire digging = (state == DL) || (state == DR);

    // Direction: 0 = left, 1 = right (encoded in state)
    wire dir_left  = (state == WL) || (state == FL) || (state == DL);
    wire dir_right = (state == WR) || (state == FR) || (state == DR);

    // Bump signals valid only when walking on stable ground
    // Stable ground means ground is 1 both prev and current cycle (no edge)
    wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

    always @(*) begin
        next_state = state; // default hold

        case(state)
            WL: begin
                // Priority: fall > dig > bump direction

                if (ground == 1'b0) begin
                    // Start falling left
                    next_state = FL;
                end else if (dig && stable_ground) begin
                    // Start digging left
                    next_state = DL;
                end else if (stable_ground && (bump_left || bump_right)) begin
                    // bump -> change direction
                    // Both bumps: toggle direction -> walking right
                    // bump_left only: walk right
                    // bump_right only: walk left (already walking left, so no change)
                    if (bump_left && bump_right) begin
                        next_state = WR;
                    end else if (bump_left) begin
                        next_state = WR;
                    end else if (bump_right) begin
                        // bump_right -> walk left: already WL, so no change
                        next_state = WL;
                    end
                end
                // else remain WL
            end

            WR: begin
                if (ground == 1'b0) begin
                    // Start falling right
                    next_state = FR;
                end else if (dig && stable_ground) begin
                    // Start digging right
                    next_state = DR;
                end else if (stable_ground && (bump_left || bump_right)) begin
                    // bump -> change direction
                    // Both bumps: toggle direction -> walking left
                    // bump_left only: walk right (already walking right)
                    // bump_right only: walk left
                    if (bump_left && bump_right) begin
                        next_state = WL;
                    end else if (bump_left) begin
                        // bump_left -> walk right, already WR, no change
                        next_state = WR;
                    end else if (bump_right) begin
                        next_state = WL;
                    end
                end
                // else remain WR
            end

            FL: begin
                // Falling left
                // Return to walking left upon ground rising edge
                if (ground == 1'b1) begin
                    next_state = WL;
                end
                // else remain falling left
            end

            FR: begin
                // Falling right
                // Return to walking right upon ground rising edge
                if (ground == 1'b1) begin
                    next_state = WR;
                end
                // else remain falling right
            end

            DL: begin
                // Digging left
                // Fall when ground disappears
                if (ground == 1'b0) begin
                    next_state = FL;
                end
                // else remain digging left
            end

            DR: begin
                // Digging right
                // Fall when ground disappears
                if (ground == 1'b0) begin
                    next_state = FR;
                end
                // else remain digging right
            end

            default: begin
                // Safety fallback to walking left
                next_state = WL;
            end
        endcase
    end

    // Outputs are combinational decoded from states (Moore FSM)
    assign walk_left  = (state == WL);
    assign walk_right = (state == WR);
    assign aaah       = (state == FL) || (state == FR);
    assign digging    = (state == DL) || (state == DR);

endmodule