module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// State definitions
enum logic [2:0] { 
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALL = 3'b011,
    DIG_LEFT = 3'b100,
    DIG_RIGHT = 3'b101,
    SPLATTER = 3'b110
} state, next_state;

// Counters
reg [5:0] fall_counter;
reg [5:0] dig_counter;

// Combinational logic for next state and outputs
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            walk_right = 1'b1;
        end
        FALL: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTER;
                end else begin
                    if (dig_counter == 0) begin
                        if (dig_counter == 0 && dig) begin
                            next_state = WALK_LEFT;
                        end else if (dig_counter == 0 && !dig) begin
                            next_state = WALK_RIGHT;
                        end
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end
        end
        DIG_LEFT: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALL;
            end
            walk_left = 1'b1;
        end
        DIG_RIGHT: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALL;
            end
            walk_right = 1'b1;
        end
        SPLATTER: begin
            // Do nothing
        end
    endcase
end

// Sequential logic for state and counters
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'd0;
        dig_counter <= 6'd0;
    end else begin
        state <= next_state;
        if (state == FALL) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'd0;
        end
        if (state == DIG_LEFT || state == DIG_RIGHT) begin
            dig_counter <= dig_counter + 1;
        end else begin
            dig_counter <= 6'd0;
        end
    end
end

endmodule