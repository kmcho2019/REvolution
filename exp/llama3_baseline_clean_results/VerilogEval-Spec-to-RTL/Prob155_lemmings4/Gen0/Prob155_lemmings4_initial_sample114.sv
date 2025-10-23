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

// Define the states
enum logic [3:0] {
    WALK_LEFT = 4'd0,
    WALK_RIGHT = 4'd1,
    FALL = 4'd2,
    DIG = 4'd3,
    SPLAT = 4'd4
} state, next_state;

// Counter for falling clock cycles
reg [5:0] fall_counter;

always @(*) begin
    // Defaults
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (dig && ground) begin
                next_state = DIG;
            end else if (!ground) begin
                next_state = FALL;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            walk_right = 1;
            if (dig && ground) begin
                next_state = DIG;
            end else if (!ground) begin
                next_state = FALL;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        FALL: begin
            aaah = 1;
            fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLAT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALL;
            end
        end

        DIG: begin
            digging = 1;
            if (!ground) begin
                next_state = FALL;
            end else begin
                next_state = DIG;
            end
        end

        SPLAT: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
            next_state = SPLAT;
        end

        default: next_state = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (next_state == FALL) begin
            fall_counter <= 1;
        end else if (next_state == WALK_LEFT || next_state == WALK_RIGHT || next_state == DIG) begin
            fall_counter <= 0;
        end else begin
            fall_counter <= fall_counter;
        end
    end
end

endmodule