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

    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    reg direction, next_direction;
    
    // Action states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    reg [1:0] action, next_action;

    // Direction FSM (only changes when walking and bumped)
    always @(*) begin
        next_direction = direction;
        if (action == WALK) begin
            case ({bump_left, bump_right})
                2'b10: next_direction = RIGHT;
                2'b01: next_direction = LEFT;
                2'b11: next_direction = ~direction; // both bumps = toggle
                default: next_direction = direction;
            endcase
        end
    end

    // Action FSM (handles state transitions)
    always @(*) begin
        next_action = action;
        case (action)
            WALK: begin
                if (!ground) begin
                    next_action = FALL;
                end else if (dig) begin
                    next_action = DIG;
                end
            end
            FALL: begin
                if (ground) begin
                    next_action = WALK;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_action = FALL;
                end
            end
        endcase
    end

    // Registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= LEFT;
            action <= WALK;
        end else begin
            direction <= next_direction;
            action <= next_action;
        end
    end

    // Output logic
    assign walk_left = (action == WALK) & (direction == LEFT);
    assign walk_right = (action == WALK) & (direction == RIGHT);
    assign aaah = (action == FALL);
    assign digging = (action == DIG);

endmodule