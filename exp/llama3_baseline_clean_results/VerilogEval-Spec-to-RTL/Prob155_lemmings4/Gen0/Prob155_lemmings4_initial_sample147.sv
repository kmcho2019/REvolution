`timescale 1ns / 1ps

module TopModule (
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

// Enum for states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALL,
    DIG_LEFT,
    DIG_RIGHT,
    SPLATTER
} state, next_state;

// Counter for falling cycles
reg [5:0] fall_count;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 6'd0;
    end else begin
        state <= next_state;
        if (next_state == FALL) begin
            fall_count <= fall_count + 1;
        end else if (state == FALL && next_state != FALL) begin
            fall_count <= 6'd0;
        end
    end
end

// Combinational logic
always @(*) begin
    // Default values
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // No change
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT; // No change
            end
        end
        FALL: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_count > 6'd20) begin
                    next_state = SPLATTER;
                end else if (state == DIG_LEFT || state == DIG_RIGHT) begin
                    next_state = state == DIG_LEFT ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
                end
            end
        end
        DIG_LEFT: begin
            digging = 1'b1;
            walk_left = 1'b1;
            if (!ground) begin
                next_state = FALL;
            end
        end
        DIG_RIGHT: begin
            digging = 1'b1;
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALL;
            end
        end
        SPLATTER: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule