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
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL       = 2'b10;
    localparam DIG        = 2'b11;
    localparam SPLATTER   = 3'b100;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer;
    reg direction;  // 0=left, 1=right

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
                else if (dig) next_state = DIG;
                else if (bump_left) next_state = WALK_RIGHT;
                else next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else if (bump_right) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end
            FALL: begin
                if (ground) begin
                    if (fall_timer > 20) next_state = SPLATTER;
                    else next_state = direction ? WALK_RIGHT : WALK_LEFT;
                end
                else next_state = FALL;
            end
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            SPLATTER: next_state = SPLATTER;
            default: next_state = WALK_LEFT;
        endcase
    end

    // State and direction register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 0;
        end else begin
            state <= next_state;
            // Update direction when walking or changing direction
            if (next_state == WALK_LEFT) direction <= 0;
            else if (next_state == WALK_RIGHT) direction <= 1;
            // Preserve direction when falling or digging
        end
    end

    // Output assignments
    assign walk_left = (state == WALK_LEFT) || (state == DIG && !direction);
    assign walk_right = (state == WALK_RIGHT) || (state == DIG && direction);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule