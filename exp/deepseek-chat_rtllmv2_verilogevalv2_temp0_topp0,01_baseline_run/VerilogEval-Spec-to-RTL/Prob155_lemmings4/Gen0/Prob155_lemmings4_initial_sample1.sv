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

    // Define states
    parameter WALK_LEFT = 0;
    parameter WALK_RIGHT = 1;
    parameter FALL_LEFT = 2;
    parameter FALL_RIGHT = 3;
    parameter DIG_LEFT = 4;
    parameter DIG_RIGHT = 5;
    parameter SPLAT = 6;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg fall_counter_reset;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
                else next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end
            FALL_LEFT: begin
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLAT;
                    else next_state = WALK_LEFT;
                end
                else next_state = FALL_LEFT;
            end
            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLAT;
                    else next_state = WALK_RIGHT;
                end
                else next_state = FALL_RIGHT;
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else next_state = DIG_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else next_state = DIG_RIGHT;
            end
            SPLAT: next_state = SPLAT;
            default: next_state = WALK_LEFT;
        endcase
    end

    // Fall counter logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else begin
            if (fall_counter_reset) begin
                fall_counter <= 0;
            end else if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_counter <= fall_counter + 1;
            end
        end
    end

    // Fall counter reset logic
    always @(*) begin
        fall_counter_reset = (state != FALL_LEFT && state != FALL_RIGHT);
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore machine)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule