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

    // State encoding
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam FALL       = 3'b010;
    localparam DIG_LEFT   = 3'b100;
    localparam DIG_RIGHT  = 3'b101;
    localparam SPLATTER   = 3'b111;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer;

    // Fall timer logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_timer <= 0;
        end else begin
            if (state == FALL) begin
                fall_timer <= ground ? 0 : fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // State transition (combinational)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
                else next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end
            FALL: begin
                if (ground)
                    next_state = (fall_timer > 20) ? SPLATTER : 
                                (state[0] ? WALK_RIGHT : WALK_LEFT);
                else
                    next_state = FALL;
            end
            DIG_LEFT: begin
                if (~ground) next_state = FALL;
                else next_state = DIG_LEFT;
            end
            DIG_RIGHT: begin
                if (~ground) next_state = FALL;
                else next_state = DIG_RIGHT;
            end
            SPLATTER: next_state = SPLATTER;
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output assignments
    assign walk_left = (state == WALK_LEFT) || (state == DIG_LEFT);
    assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule