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

// Define FSM states (3-bit encoding)
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam DIG_LEFT   = 3'd2;
localparam DIG_RIGHT  = 3'd3;
localparam FALL_LEFT  = 3'd4;
localparam FALL_RIGHT = 3'd5;
localparam SPLAT      = 3'd6;

reg [2:0] state, next_state;
reg [5:0] fall_counter, next_fall_counter; // 6 bits to comfortably count >20

// Helper functions to extract direction from state
// direction = 0 for left, 1 for right
function direction_from_state(input [2:0] s);
    begin
        case (s)
            WALK_LEFT, DIG_LEFT, FALL_LEFT: direction_from_state = 1'b0;
            WALK_RIGHT, DIG_RIGHT, FALL_RIGHT: direction_from_state = 1'b1;
            default: direction_from_state = 1'b0;
        endcase
    end
endfunction

// Helper to build state with direction
function [2:0] walk_state(input dir);
    walk_state = (dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
endfunction

function [2:0] dig_state(input dir);
    dig_state = (dir == 1'b0) ? DIG_LEFT : DIG_RIGHT;
endfunction

function [2:0] fall_state(input dir);
    fall_state = (dir == 1'b0) ? FALL_LEFT : FALL_RIGHT;
endfunction

// Combinational logic for next state and fall_counter
always @* begin
    // Default: hold state and counter
    next_state = state;
    next_fall_counter = fall_counter;

    // Extract current direction
    wire dir = direction_from_state(state);

    case (state)
        WALK_LEFT, WALK_RIGHT: begin
            if (!ground) begin
                // Lose ground: start falling with current direction
                next_state = fall_state(dir);
                next_fall_counter = 6'd1; // start counting fall from 1
            end else if (dig) begin
                // Start digging if requested and on ground
                next_state = dig_state(dir);
                next_fall_counter = 6'd0;
            end else if (bump_left && bump_right) begin
                // Both bumps: switch direction
                next_state = walk_state(~dir);
                next_fall_counter = 6'd0;
            end else if (bump_left) begin
                // bump_left => walk right
                next_state = WALK_RIGHT;
                next_fall_counter = 6'd0;
            end else if (bump_right) begin
                // bump_right => walk left
                next_state = WALK_LEFT;
                next_fall_counter = 6'd0;
            end else begin
                // Keep walking same direction
                next_state = state;
                next_fall_counter = 6'd0;
            end
        end

        DIG_LEFT, DIG_RIGHT: begin
            if (!ground) begin
                // Start falling with current direction
                next_state = fall_state(dir);
                next_fall_counter = 6'd1; // start counting fall
            end else begin
                // Continue digging
                next_state = state;
                next_fall_counter = 6'd0;
            end
            // bumps and dig inputs ignored in dig mode
        end

        FALL_LEFT, FALL_RIGHT: begin
            if (ground) begin
                // Landed: check fall_counter for splatter
                if (fall_counter > 6'd20) begin
                    next_state = SPLAT;
                    next_fall_counter = 6'd0;
                end else begin
                    // recover to walking same direction
                    next_state = walk_state(dir);
                    next_fall_counter = 6'd0;
                end
            end else begin
                // Still falling: increment counter saturating at 63
                next_state = state;
                if (fall_counter < 6'd63)
                    next_fall_counter = fall_counter + 6'd1;
                else
                    next_fall_counter = fall_counter;
            end
            // bumps and dig inputs ignored in fall mode
        end

        SPLAT: begin
            // Terminal splat state, no transitions
            next_state = SPLAT;
            next_fall_counter = 6'd0;
        end

        default: begin
            // Recover safe defaults if undefined state
            next_state = WALK_LEFT;
            next_fall_counter = 6'd0;
        end
    endcase
end

// Sequential logic with async posedge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

// Output decoding
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule